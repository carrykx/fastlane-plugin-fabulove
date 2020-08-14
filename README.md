# fabulove plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-fabulove)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-fabulove`, add it to your project by running:

```bash
fastlane add_plugin fabulove
```

## About fabulove

"fabulove" distribution system fastlane plugin, upload ipa or apk to fabulove.
```bash
fabulove(
      username: "username",
      password: "password",
      base_url: "https://fabulove.com", // 域名
      team_id: "xxxxxxxxxxx",
      file_path: app_patch,  // ipa/apk包路径
      keep_app_versions_num: 10  // 为节省服务器空间，设置保留的版本数量，如果超过则会自动删除最早的一个版本。如设0则不进行处理。
    )
```

**Note to author:** Add a more detailed description about this plugin here. If your plugin contains multiple actions, make sure to mention them here.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)


## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
