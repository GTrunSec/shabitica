{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Arrow (first)
import Data.Maybe (fromMaybe)
import System.Posix.Internals (setNonBlockingFD)
import System.Environment (lookupEnv)
import System.IO (hPrint, stderr)
import Network.Mail.Mime (simpleMail', renderSendMailCustom, Mail)
import Network.Wai (Application)
import System.Systemd.Daemon (getActivatedSockets)
import Network.Socket (fdSocket)

import qualified Data.Aeson as J
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Network.HTTP.Types as HT
import qualified Network.Wai as W
import qualified Network.Wai.Handler.Warp as Warp

import Types (SimpleMail(smTo), TxnMail(txnTo),
              RenderedMail(..), JsonResponse(..), Address(..))
import Render (renderSimpleMail, renderTxnMail)

data Settings = Settings
    { fromEmail :: Address
    , sendmailPath :: FilePath
    } deriving Show

sender :: Address
sender = Address (Just "SHabitica") "admin@example.org"

renderMimeTxnMails :: Settings -> TxnMail -> ([T.Text], [Mail])
renderMimeTxnMails s txn =
    first concat . unzip . fmap mkMail $ txnTo txn
  where
    mkMail to =
        (warnings, sm)
      where
        sm = simpleMail' to (fromEmail s) (subject rendered) (body rendered)
        (warnings, rendered) = renderTxnMail to txn

handleTxnMail :: Settings -> TxnMail -> IO JsonResponse
handleTxnMail s txn = do
    mapM_ (TIO.hPutStrLn stderr) warnings
    mapM_ (renderSendMailCustom (sendmailPath s) ["-t"]) mails
    return JsonOk
  where
    (warnings, mails) = renderMimeTxnMails s txn

handleSimpleMail :: Settings -> SimpleMail -> IO JsonResponse
handleSimpleMail s sm = do
    renderSendMailCustom (sendmailPath s) ["-t"] $
        simpleMail' (smTo sm) (fromEmail s) subj bdy
    return JsonOk
  where
    RenderedMail { subject = subj, body = bdy } = renderSimpleMail sm

responseJson :: J.ToJSON a => HT.Status -> a -> W.Response
responseJson status =
    W.responseLBS status jsonHeaders . J.encode
  where
    jsonHeaders = [("Content-Type", "application/json")]

wrapJson :: J.FromJSON a => (a -> IO JsonResponse) -> Application
wrapJson fun req respond = do
    reqBody <- W.strictRequestBody req
    hPrint stderr reqBody
    case J.eitherDecode reqBody of
         Left err -> do
             hPrint stderr err
             respond . responseJson HT.status400 . JsonErr $ T.pack err
         Right val -> do
             result <- fun val
             case result of
                  JsonOk -> respond $ responseJson HT.status200 JsonOk
                  e@(JsonErr _) -> respond $ responseJson HT.status500 e

handler :: Settings -> Application
handler s req respond =
    case W.pathInfo req of
         ["job"] -> wrapJson (handleTxnMail s) req respond
         ["simple-mail"] -> wrapJson (handleSimpleMail s) req respond
         _ -> respond $ responseJson HT.status404 $ JsonErr "path not found"

warpSettings :: Warp.Settings
warpSettings =
    Warp.setLogger logger Warp.defaultSettings
  where
    logger req _ _ = hPrint stderr req

readSettings :: IO Settings
readSettings = do
    addr <- maybe "unconfigured@example.org" T.pack <$> lookupEnv "MAIL_FROM"
    sm <- fromMaybe "/run/wrappers/bin/sendmail" <$> lookupEnv "SENDMAIL_PATH"
    return $ Settings (Address (Just "SHabitica") addr) sm

main :: IO ()
main = do
    settings <- readSettings
    socks <- getActivatedSockets
    case socks of
         Just allsocks@(s:_) -> do
             mapM_ (flip setNonBlockingFD True . fdSocket) allsocks
             Warp.runSettingsSocket warpSettings s (handler settings)
         _ -> Warp.runSettings warpSettings (handler settings)