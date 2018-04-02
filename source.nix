{ stdenv, lib, runCommand, fetchFromGitHub, nodePackages, habiticaConfig }:

stdenv.mkDerivation rec {
  name = "habitica-source-patched-${version}";
  # NOTE: Be sure to run update-deps.py after changing this!
  version = "4.34.1";

  src = fetchFromGitHub {
    name = "habitica-source-${version}";
    owner = "HabitRPG";
    repo = "habitica";
    rev = "v${version}";
    sha256 = "1wcdp0yy50m2irnrwhxs30mcz726bfwn5ipzr6adqyvm0za4h6vv";
  };

  phases = [ "unpackPhase" "patchPhase" "checkPhase" "installPhase" ];

  patches = [
    # Remove all unneeded dependencies (eg. to external services and payment)
    patches/strip-dependencies.patch

    # Support systemd socket activation.
    patches/socket-activation.patch

    # Fix infinite redirection occuring whenever the BASE_URL contains a port
    # number.
    patches/redirect-fix-port.patch

    # Everybody gets a lifetime subscription.
    patches/subscriptions4all.patch

    # Remove payment, analytics and other external services.
    patches/remove-external-services.patch

    # Don't allow anonymous users to register, we only want to invite people.
    patches/invite-only.patch

    # Poor mans sendmail implementation, because the official Habitica instance
    # uses MailChimp and it appears that the templates reside on their account.
    patches/sendmail.patch

    # Official Habitica has different mail addresses for different positions,
    # but for a private instance this is not really necessary. So let's use
    # ADMIN_EMAIL everywhere.
    patches/one-admin-mailaddr.patch

    # This thing takes way too much space, so let's remove it.
    patches/kill-footer.patch

    # Registration is allowed for the first user of the instance.
    patches/allow-register-first.patch

    # Don't try to charge for group plans.
    patches/free-group-plans.patch

    # We have subscriptions for all, so let's allow to change group leader in a
    # group that has a subscription.
    patches/always-permit-group-leader-change.patch

    # Don't restrict to use email domains such as habitica.com or habitrpg.com.
    patches/dont-restrict-email-domains.patch

    # Fix an import of "../../../../website/common" to not use "../website".
    patches/fix-server-common-import.patch

    # Force webpack to use NODE_PATH.
    patches/webpack-node-path.patch

    # Hardcode the server version using substituteInPlace below.
    patches/hardcoded-server-version.patch

    # Don't serve static files as we do have a web server for that.
    patches/remove-static-middleware.patch

    # Correctly serve the client's index.html (patched using substituteInPlace
    # in habitica.nix).
    patches/server-client-path.patch

    # Fixes a circular import happening with spells.js and it's the reason why
    # spells weren't working from within the UI.
    patches/fix-client-circular-import.patch

    # Changes the privacy policy to be less awful.
    patches/privacy-policy.patch

    # Import moment by importing moment-recur instead.
    patches/fix-moment-recur-import.patch

    # Do not limit the amount of gems somebody can buy for gold.
    patches/no-limit-for-gold-to-gems.patch

    # Remove the SESSION_SECRET* variables from the example config, because
    # we're going to generate them on first start of the service and provide
    # them via environment variables.
    patches/remove-session-secret-from-config.patch

    # Remove the contact form which is also transmitting user data to
    # https://contact.habitica.com/.
    patches/remove-contact-form.patch

    # We don't need the community guidelines for our standalone version.
    patches/remove-community-guidelines.patch

    # Temporary until news.js gets updated. We have a canary for instagram,
    # Facebook and so on, so let's remove the links.
    patches/news-remove-instagram.patch

    # Remove external links, such as to Trello tickets and official guilds that
    # do not exist on our instance.
    patches/remove-external-links.patch

    # Those staff members don't exist on our version and tiers are also not
    # very useful for self-hosted instances.
    patches/tavern-remove-staff-and-tiers.patch

    # Remove links to press kit, merch and group plans.
    patches/remove-presskit-merch-plans.patch

    # Everything in our instance is free, so don't remove subscriptions (it
    # won't make a difference anyway though).
    patches/dont-cancel-group-subscription-on-leave.patch
  ];

  patchFlags = [ "--no-backup-if-mismatch" "-p1" ];

  # Kill off files we do not want to have, most of them because they redirect
  # to external services:
  prePatch = lib.concatMapStrings (path: ''
    rm -r ${lib.escapeShellArg path}
  '') [
    "scripts/paypalBillingSetup.js"
    "website/client/components/groups/communityGuidelines.vue"
    "website/client/components/payments/amazonModal.vue"
    "website/client/components/payments/buyGemsModal.vue"
    "website/client/components/payments/sendGemsModal.vue"
    "website/client/components/static/communityGuidelines.vue"
    "website/client/components/static/contact.vue"
    "website/client/components/static/groupPlans.vue"
    "website/client/components/static/merch.vue"
    "website/client/components/static/pressKit.vue"
    "website/client/libs/analytics.js"
    "website/client/libs/logging.js"
    "website/client/libs/modform.js"
    "website/client/libs/payments.js"
    "website/client/mixins/payments.js"
    "website/server/controllers/api-v3/iap.js"
    "website/server/controllers/top-level/payments/amazon.js"
    "website/server/controllers/top-level/payments/iap.js"
    "website/server/controllers/top-level/payments/paypal.js"
    "website/server/controllers/top-level/payments/stripe.js"
    "website/server/libs/amazonPayments.js"
    "website/server/libs/analyticsService.js"
    "website/server/libs/applePayments.js"
    "website/server/libs/aws.js"
    "website/server/libs/googlePayments.js"
    "website/server/libs/inAppPurchases.js"
    "website/server/libs/paypalPayments.js"
    "website/server/libs/pushNotifications.js"
    "website/server/libs/pusher.js"
    "website/server/libs/queue/index.js"
    "website/server/libs/slack.js"
    "website/server/libs/stripePayments.js"
    "website/server/middlewares/analytics.js"
    "website/server/middlewares/static.js"
    "website/static/emails"
    "website/static/merch"
    "website/static/presskit"
  ];

  # We don't want to have anything in the code referencing any of these
  # words/regexes:
  disallowedCanaries = lib.concatStringsSep "\\|" (functionCanaries ++ [
    "/groups/guild/[a-f0-9-]\\{36\\}"
    "EMAILS:[A-Z]"
    "\\<apn"
    "\\<buygemsmodal\\>"
    "\\<merch\\>"
    "\\<payments\\>"
    "\\<sendgemsmodal\\>"
    "amazon"
    "amz"
    "analytics"
    "apple"
    "communityguidelines"
    "facebook"
    "fcm"
    "gcm"
    "google"
    "habitica\\.com"
    "hellojs"
    "instagram"
    "itunes"
    "kafka"
    "loggly"
    "paypal"
    "play.*api"
    "play.*store"
    "press.\\?kit"
    "pushnotif"
    "slack"
    "social"
    "stripe[^d]"
    "transifex"
    "trello"
    "tumblr"
    "twitter"
  ]);

  # These are for changed function arguments, because we don't want to miss
  # these in future upstream updates. Use 'find-canaries.py' to find these.
  functionCanaries = [
    "BuyMarketGearOperation([^,]*,[^,)]*,"
    "buy([^,]*,[^,)]*,"
    "buyArmoire([^,]*,[^,)]*,"
    "buyGems([^,]*,[^,)]*,"
    "buyGems([^,]*,[^,]*,[^,)]*,"
    "buyHealthPotion([^,]*,[^,)]*,"
    "buyMysterySet([^,]*,[^,)]*,"
    "buyQuest([^,]*,[^,)]*,"
    "buySpecialSpell([^,]*,[^,)]*,"
    "changeClass([^,]*,[^,)]*,"
    "cron([^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,)]*,"
    "hourglassPurchase([^,]*,[^,)]*,"
    "openMysteryItem([^,]*,[^,)]*,"
    "purchaseOp([^,]*,[^{,)]*,"
    "rebirth([^,]*,[^,]*,[^,)]*,"
    "releaseBoth([^,]*,[^,)]*,"
    "releaseMounts([^,]*,[^,)]*,"
    "releasePets([^,]*,[^,)]*,"
    "reroll([^,]*,[^,]*,[^,)]*,"
    "revive([^,]*,[^,)]*,"
    "sleep([^,]*,[^,)]*,"
    "unlock([^,]*,[^,)]*,"
    "updateGroupPlan([^)]"
    "updateStats([^,]*,[^,)]*,"
  ];

  excludedCanaryPaths = let
    mkExclude = path: "-path ${lib.escapeShellArg "./${path}"} -prune";
  in lib.concatMapStringsSep " -o " mkExclude [
    ".github"
    "Dockerfile-Production"
    "database_reports"
    "gulp"
    "migrations"
    "node_modules"
    "package-lock.json"
    "package.json"
    "test"
    "website/README.md"
    "website/client/assets"
    "website/client/components/settings/api.vue"
    "website/client/components/static/privacy.vue"
    "website/client/components/static/terms.vue"
    "website/common/locales"
    "website/raw_sprites"
    "website/server/libs/bannedWords.js"
    "website/static/audio"
    "website/static/merch"
    "website/static/presskit"
  ];

  # Change all habitica.com URLs to use BASE_URL and all hardcoded email
  # addresses to use ADMIN_EMAIL:
  rewriteHabiticaURIs = let
    sedEscape = lib.escape ["\\" "&" "!"];
    mkHtmlMail = lib.replaceStrings ["@" "."] ["&commat;" "&period;"];

    escBaseURL = sedEscape habiticaConfig.BASE_URL;
    escSimpleMail = sedEscape habiticaConfig.ADMIN_EMAIL;
    escHtmlMail = sedEscape (mkHtmlMail habiticaConfig.ADMIN_EMAIL);

  in lib.concatStringsSep "; " [
    "s!https\\?://habitica\\.com!${escBaseURL}!g"
    "s![a-z]\\+@habitica\\.com!${escSimpleMail}!g"
    "s![a-z]\\+&commat;habitica&period;com!${escHtmlMail}!g"
  ];

  postPatch = ''
    # See 'rewriteHabiticaURIs' attribute above.
    find . -path ./test -prune -o -path ./website/static -prune -o \
      -type f -exec sed -i -e "$rewriteHabiticaURIs" {} +

    echo "checking whether we have external services in the code..." >&2
    extServices="$(
      eval find . $excludedCanaryPaths -o -type f \
        -exec grep -Hi '"$disallowedCanaries"' {} + || :
    )"

    # Hardcode version in the server (see hardcoded-server-version.patch).
    substituteInPlace website/server/middlewares/response.js \
      --subst-var-by HABITICA_VERSION "$version"

    extServicesWithoutFalsePositives="$(echo "$extServices" \
      | grep -v 'user/schema\.js:.*\(facebook\|google\)' \
      | grep -v 'user/methods\.js:.*\<payments\>' \
      | grep -v 'models/group\.js:.*\<payments\>' \
      | grep -v 'settings/api\.vue:.*chrome\.google\.com/webstore' \
      | grep -v 'top-level/pages\.js:// All' \
      | grep -v 'api-v3/tasks\.js: *//.*pushNotif' \
      | grep -v 'user/schema\.js: *pushNotifications:' \
      | grep -v 'user/methods\.js:schema\.statics\.pushNotification' \
      | grep -v 'api-v3/groups.js:.*payments' \
      | grep -v 'libs/bannedSlurs.js://.*socialites' \
      || :)"

    if [ -n "$extServicesWithoutFalsePositives" ]; then
      echo "FATAL: We still have occurences of external services here:" >&2
      echo "$extServicesWithoutFalsePositives" >&2
      exit 1
    fi

    cp --no-preserve=mode -rt website/static "$googleFonts/fonts"
    cp --no-preserve=mode -rt website/static "$emojis/public/graphics/emojis"
  '';

  googleFonts = runCommand "google-fonts" {
    name = "google-fonts";
    outputHashAlgo = "sha256";
    outputHash = "09sk5s4abrrwpxvzajc0lyq8i15p77vjr0brh8jq0pi2s2fnadi9";
    outputHashMode = "recursive";
    nativeBuildInputs = [ nodePackages.extra.google-fonts-offline ];
    inherit src;
  } ''
    fontURL="$(sed -n \
      -e '/fonts\.googleapis/s/^.*href="\([^"]\+\)".*$/\1/p' \
      "$src/website/client/index.html")"
    mkdir "$out"
    ( cd "$out"
      goofoffline outCss=fonts.css "$fontURL"
    )
  '';

  emojis = fetchFromGitHub {
    owner = "WebpageFX";
    repo = "emoji-cheat-sheet.com";
    rev = "c59bf0aad0a7238050c1a3896ecad650af227d59";
    sha256 = "1s696nsvndp4p697yiaq908s387gc0m2xmby7cab071xf2p8c4h7";
  };

  doCheck = true;

  # We only do an ESLint check here, to make sure the source is in good shape
  # after our patches. The actual unit tests are not part of the source
  # preparation and are done elsewhere.
  checkPhase = let
    eslintNodePath = let
      isEslint = name: lib.hasPrefix "eslint" name || name == "babel-eslint";
      devAndMain = nodePackages.dev // nodePackages.main;
      eslintDeps = lib.filterAttrs (n: lib.const (isEslint n)) devAndMain;
      mkSubdep = p: "${p}/lib/node_modules/${p.packageName}/node_modules";
      mkDep = p: "${p}/lib/node_modules:${mkSubdep p}";
    in lib.concatMapStringsSep ":" mkDep (lib.attrValues eslintDeps);
    eslintCmd = lib.concatMapStringsSep " " lib.escapeShellArg [
      "${nodePackages.dev.eslint}/bin/eslint" "--ext" ".js,.vue" "."
    ];
  in "NODE_PATH=${lib.escapeShellArg eslintNodePath} ${eslintCmd}";

  installPhase = "cp -r . \"$out\"";
}