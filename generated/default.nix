{ pkgs ? import <nixpkgs> { inherit system; }
, system ? builtins.currentSystem
}:

let
  nodePackages = import ./all-deps.nix { inherit pkgs system; };
in {
  dev = {
    "@vue/test-utils" = nodePackages."@vue/test-utils-^1.0.0-beta.15";
    "babel-plugin-istanbul" = nodePackages."babel-plugin-istanbul-^4.1.6";
    "babel-plugin-syntax-object-rest-spread" = nodePackages."babel-plugin-syntax-object-rest-spread-^6.13.0";
    chai = nodePackages."chai-^4.1.2";
    "chai-as-promised" = nodePackages."chai-as-promised-^7.1.1";
    chalk = nodePackages."chalk-^2.4.1";
    chromedriver = nodePackages."chromedriver-^2.38.2";
    "connect-history-api-fallback" = nodePackages."connect-history-api-fallback-^1.1.0";
    coveralls = nodePackages."coveralls-^3.0.1";
    "cross-spawn" = nodePackages."cross-spawn-^6.0.5";
    eslint = nodePackages."eslint-^4.19.1";
    "eslint-config-habitrpg" = nodePackages."eslint-config-habitrpg-^4.0.0";
    "eslint-friendly-formatter" = nodePackages."eslint-friendly-formatter-^4.0.1";
    "eslint-loader" = nodePackages."eslint-loader-^2.0.0";
    "eslint-plugin-html" = nodePackages."eslint-plugin-html-^4.0.3";
    "eslint-plugin-mocha" = nodePackages."eslint-plugin-mocha-^5.0.0";
    "eventsource-polyfill" = nodePackages."eventsource-polyfill-^0.9.6";
    "expect.js" = nodePackages."expect.js-^0.3.1";
    "http-proxy-middleware" = nodePackages."http-proxy-middleware-^0.18.0";
    istanbul = nodePackages."istanbul-^1.1.0-alpha.1";
    karma = nodePackages."karma-^2.0.2";
    "karma-babel-preprocessor" = nodePackages."karma-babel-preprocessor-^7.0.0";
    "karma-chai-plugins" = nodePackages."karma-chai-plugins-^0.9.0";
    "karma-chrome-launcher" = nodePackages."karma-chrome-launcher-^2.2.0";
    "karma-coverage" = nodePackages."karma-coverage-^1.1.2";
    "karma-mocha" = nodePackages."karma-mocha-^1.3.0";
    "karma-mocha-reporter" = nodePackages."karma-mocha-reporter-^2.2.5";
    "karma-sinon-chai" = nodePackages."karma-sinon-chai-^1.3.4";
    "karma-sinon-stub-promise" = nodePackages."karma-sinon-stub-promise-^1.0.0";
    "karma-sourcemap-loader" = nodePackages."karma-sourcemap-loader-^0.3.7";
    "karma-spec-reporter" = nodePackages."karma-spec-reporter-0.0.32";
    "karma-webpack" = nodePackages."karma-webpack-^3.0.0";
    "lcov-result-merger" = nodePackages."lcov-result-merger-^2.0.0";
    mocha = nodePackages."mocha-^5.1.1";
    "mocha-multi-reporters" = nodePackages."mocha-multi-reporters-^1.1.7";
    "mocha-simple-html-reporter" = nodePackages."mocha-simple-html-reporter-^1.1.0";
    monk = nodePackages."monk-^6.0.6";
    nightwatch = nodePackages."nightwatch-^0.9.21";
    "nightwatch-html-reporter" = nodePackages."nightwatch-html-reporter-^2.0.5";
    puppeteer = nodePackages."puppeteer-^1.4.0";
    "require-again" = nodePackages."require-again-^2.0.0";
    "selenium-server" = nodePackages."selenium-server-^3.12.0";
    sinon = nodePackages."sinon-^4.5.0";
    "sinon-chai" = nodePackages."sinon-chai-^3.0.0";
    "sinon-stub-promise" = nodePackages."sinon-stub-promise-^4.0.0";
    "webpack-bundle-analyzer" = nodePackages."webpack-bundle-analyzer-^2.11.2";
    "webpack-dev-middleware" = nodePackages."webpack-dev-middleware-^2.0.5";
    "webpack-hot-middleware" = nodePackages."webpack-hot-middleware-^2.22.1";
  };
  extra."google-fonts-offline" = nodePackages."google-fonts-offline";
  main = {
    accepts = nodePackages."accepts-^1.3.5";
    apidoc = nodePackages."apidoc-^0.17.5";
    autoprefixer = nodePackages."autoprefixer-^8.4.1";
    axios = nodePackages."axios-^0.18.0";
    "axios-progress-bar" = nodePackages."axios-progress-bar-^1.2.0";
    "babel-core" = nodePackages."babel-core-^6.26.3";
    "babel-eslint" = nodePackages."babel-eslint-^8.2.3";
    "babel-loader" = nodePackages."babel-loader-^7.1.4";
    "babel-plugin-syntax-async-functions" = nodePackages."babel-plugin-syntax-async-functions-^6.13.0";
    "babel-plugin-syntax-dynamic-import" = nodePackages."babel-plugin-syntax-dynamic-import-^6.18.0";
    "babel-plugin-transform-es2015-modules-commonjs" = nodePackages."babel-plugin-transform-es2015-modules-commonjs-^6.26.2";
    "babel-plugin-transform-object-rest-spread" = nodePackages."babel-plugin-transform-object-rest-spread-^6.16.0";
    "babel-plugin-transform-regenerator" = nodePackages."babel-plugin-transform-regenerator-^6.16.1";
    "babel-polyfill" = nodePackages."babel-polyfill-^6.6.1";
    "babel-preset-es2015" = nodePackages."babel-preset-es2015-^6.6.0";
    "babel-register" = nodePackages."babel-register-^6.6.0";
    "babel-runtime" = nodePackages."babel-runtime-^6.11.6";
    bcrypt = nodePackages."bcrypt-^2.0.0";
    "body-parser" = nodePackages."body-parser-^1.15.0";
    bootstrap = nodePackages."bootstrap-4.1.0";
    "bootstrap-vue" = nodePackages."bootstrap-vue-^2.0.0-rc.9";
    compression = nodePackages."compression-^1.7.2";
    "cookie-session" = nodePackages."cookie-session-^1.2.0";
    "coupon-code" = nodePackages."coupon-code-^0.4.5";
    "cross-env" = nodePackages."cross-env-^5.1.5";
    "css-loader" = nodePackages."css-loader-^0.28.11";
    "csv-stringify" = nodePackages."csv-stringify-^2.1.0";
    cwait = nodePackages."cwait-^1.1.1";
    "domain-middleware" = nodePackages."domain-middleware-~0.1.0";
    express = nodePackages."express-^4.16.3";
    "express-basic-auth" = nodePackages."express-basic-auth-^1.1.5";
    "express-validator" = nodePackages."express-validator-^5.2.0";
    "extract-text-webpack-plugin" = nodePackages."extract-text-webpack-plugin-^3.0.2";
    glob = nodePackages."glob-^7.1.2";
    got = nodePackages."got-^8.3.1";
    gulp = nodePackages."gulp-^4.0.0";
    "gulp-babel" = nodePackages."gulp-babel-^7.0.1";
    "gulp-imagemin" = nodePackages."gulp-imagemin-^4.1.0";
    "gulp-nodemon" = nodePackages."gulp-nodemon-^2.2.1";
    "gulp.spritesmith" = nodePackages."gulp.spritesmith-^6.9.0";
    "habitica-markdown" = nodePackages."habitica-markdown-^1.3.0";
    "html-webpack-plugin" = nodePackages."html-webpack-plugin-^3.2.0";
    "image-size" = nodePackages."image-size-^0.6.2";
    "intro.js" = nodePackages."intro.js-^2.9.3";
    jquery = nodePackages."jquery->=3.0.0";
    js2xmlparser = nodePackages."js2xmlparser-^3.0.0";
    lodash = nodePackages."lodash-^4.17.10";
    "merge-stream" = nodePackages."merge-stream-^1.0.0";
    "method-override" = nodePackages."method-override-^2.3.5";
    moment = nodePackages."moment-^2.22.1";
    "moment-recur" = nodePackages."moment-recur-^1.0.7";
    mongoose = nodePackages."mongoose-^5.0.17";
    morgan = nodePackages."morgan-^1.7.0";
    nconf = nodePackages."nconf-^0.10.0";
    "node-sass" = nodePackages."node-sass-^4.9.0";
    nodemailer = nodePackages."nodemailer-^4.6.4";
    ora = nodePackages."ora-^2.1.0";
    pageres = nodePackages."pageres-^4.1.1";
    passport = nodePackages."passport-^0.4.0";
    "popper.js" = nodePackages."popper.js-^1.14.3";
    "postcss-easy-import" = nodePackages."postcss-easy-import-^3.0.0";
    "ps-tree" = nodePackages."ps-tree-^1.0.0";
    pug = nodePackages."pug-^2.0.3";
    rimraf = nodePackages."rimraf-^2.4.3";
    "sass-loader" = nodePackages."sass-loader-^7.0.0";
    "sd-notify" = nodePackages."sd-notify-^2.3.0";
    shelljs = nodePackages."shelljs-^0.8.2";
    superagent = nodePackages."superagent-^3.8.3";
    "svg-inline-loader" = nodePackages."svg-inline-loader-^0.8.0";
    "svg-url-loader" = nodePackages."svg-url-loader-^2.3.2";
    svgo = nodePackages."svgo-^1.0.5";
    "svgo-loader" = nodePackages."svgo-loader-^2.1.0";
    "systemd-socket" = nodePackages."systemd-socket-^0.0.0";
    "url-loader" = nodePackages."url-loader-^1.0.0";
    useragent = nodePackages."useragent-^2.1.9";
    uuid = nodePackages."uuid-^3.0.1";
    validator = nodePackages."validator-^9.4.1";
    "vinyl-buffer" = nodePackages."vinyl-buffer-^1.0.1";
    vue = nodePackages."vue-^2.5.16";
    "vue-loader" = nodePackages."vue-loader-^14.2.2";
    "vue-mugen-scroll" = nodePackages."vue-mugen-scroll-^0.2.1";
    "vue-router" = nodePackages."vue-router-^3.0.0";
    "vue-style-loader" = nodePackages."vue-style-loader-^4.1.0";
    "vue-template-compiler" = nodePackages."vue-template-compiler-^2.5.16";
    vuedraggable = nodePackages."vuedraggable-^2.15.0";
    "vuejs-datepicker" = nodePackages."vuejs-datepicker-git://github.com/habitrpg/vuejs-datepicker.git#5d237615463a84a23dd6f3f77c6ab577d68593ec";
    webpack = nodePackages."webpack-^3.11.0";
    "webpack-merge" = nodePackages."webpack-merge-^4.0.0";
    winston = nodePackages."winston-^2.4.2";
    xml2js = nodePackages."xml2js-^0.4.4";
  };
}
