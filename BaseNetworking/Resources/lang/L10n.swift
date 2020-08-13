// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Hello
  internal static var hello: String { L10n.tr("Localizable", "hello") }
  /// Pull to refresh
  internal static var pullToRefresh: String { L10n.tr("Localizable", "pull_to_refresh") }

  internal enum Main {
    /// Hello %@
    internal static func hello(_ p1: String) -> String {
      return L10n.tr("Localizable", "Main.hello", p1)
    }
    /// Setting
    internal static var setting: String { L10n.tr("Localizable", "Main.Setting") }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let languageCode = Language.sharedInstance.languageCode.rawValue
    guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
      let bundle = Bundle(path: path) else {
        return NSLocalizedString(key, comment: "")
    }
    let defaultValue: String
    if let path = Bundle.main.path(forResource: LanguageCode.english.rawValue, ofType: "lproj"),
      let englishBundle = Bundle(path: path) {
      defaultValue = NSLocalizedString(key, tableName: table, bundle: englishBundle, comment: "")
    } else {
      defaultValue = NSLocalizedString(key, comment: "")
    }
    let format = NSLocalizedString(key, tableName: table, bundle: bundle, value: defaultValue, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
