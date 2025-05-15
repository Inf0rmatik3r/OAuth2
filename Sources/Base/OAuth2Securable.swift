//
//  OAuth2Requestable.swift
//  OAuth2
//
//  Created by Pascal Pfiffner on 6/2/15.
//  Copyright 2015 Pascal Pfiffner
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation


/**
Base class to add keychain storage functionality.
*/
open class OAuth2Securable: OAuth2Requestable {
	
	/// Server-side settings, as set upon initialization.
	final let settings: OAuth2JSON
	
	/// If set to `true` (the default) will use system keychain to store tokens. Use `"keychain": bool` in settings.
	public var useKeychain = false
	
	/// The keychain account to use to store tokens. Defaults to "currentTokens".
	open var keychainAccountForTokens = "currentTokens" {
		didSet {
			assert(!keychainAccountForTokens.isEmpty)
		}
	}
	
	/// The keychain account name to use to store client credentials. Defaults to "clientCredentials".
	open var keychainAccountForClientCredentials = "clientCredentials" {
		didSet {
			assert(!keychainAccountForClientCredentials.isEmpty)
		}
	}
	
	/// Defaults to `kSecAttrAccessibleWhenUnlocked`. MUST be set via `keychain_access_group` init setting.
	open internal(set) var keychainAccessMode = kSecAttrAccessibleWhenUnlocked
	
	/// Keychain access group, none is set by default. MUST be set via `keychain_access_group` init setting.
	open internal(set) var keychainAccessGroup: String?
	
	
	/**
	Base initializer.
	
	Looks at the `verbose`, `keychain`, `keychain_access_mode`, `keychain_access_group` `keychain_account_for_client_credentials` and `keychain_account_for_tokens`. Everything else is handled by subclasses.
	*/
	public init(settings: OAuth2JSON) {
		self.settings = settings
		
		// keychain settings
		if let accountForClientCredentials = settings["keychain_account_for_client_credentials"] as? String {
			keychainAccountForClientCredentials = accountForClientCredentials
		}
		if let accountForTokens = settings["keychain_account_for_tokens"] as? String {
			keychainAccountForTokens = accountForTokens
		}
		if let keychain = settings["keychain"] as? Bool {
			useKeychain = keychain
		}
		if let accessMode = settings["keychain_access_mode"] as? String {
			keychainAccessMode = accessMode as CFString
		}
		if let accessGroup = settings["keychain_access_group"] as? String {
			keychainAccessGroup = accessGroup
		}
		
		// logging settings
		var verbose = false
		if let verb = settings["verbose"] as? Bool {
			verbose = verb
		}
		super.init(verbose: verbose)
	}
}

