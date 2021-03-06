/**
 * @accessors true
 * @namespace data
 * @scope request
 */
component {

	property config;
	property key;

	public any function init(string scope) {

		var metaData = getMetaData(this);

		variables.scope = metaData.scope;

		if (structKeyExists(metaData, "namespace")) {
			variables.namespace = metaData.namespace;
		}
		else {
			variables.namespace = listLast(metaData.fullname, ".");
		}

		if (structKeyExists(arguments, "scope")) {
			variables.scope = arguments.scope;
		}

		return this;

	}

	public void function append(required string key, required any value) {
		var data = get(key, []);
		arrayAppend(data, value);
	}

	public void function clear(any key) {
		var data = getScope();
		structDelete(data, key);
	}

	public any function get(string key, any def="") {

		var data = getScope();

		if (structKeyExists(arguments, "key")) {

			if (!structKeyExists(data, arguments.key)) {
				data[arguments.key] = def;
			}

			return data[arguments.key];

		}
		else {
			return data;
		}

	}

	public string function getKey() {

		if (!structKeyExists(variables, "key")) {
			variables.key = config.get("key");
		}

		return variables.key;

	}

	private any function getOrSet(required string key, struct collection) {

		if (structKeyExists(collection, 1)) {
			return set(key, collection[1]);
		}

		return get(key);

	}

	private struct function getScope() {

		var data = "";
		var key = getKey();

		switch(scope) {
			case "application": {
				data = application;
				break;
			}
			case "session": {
				data = session;
				break;
			}
			case "request": {
				data = request;
				break;
			}
		}

		if (!structKeyExists(data, key)) {
			data[key] = {};
		}

		if (namespace == "") {
			return data[key];
		}

		if (!structKeyExists(data[key], namespace)) {
			data[key][namespace] = {};
		}

		return data[key][namespace];

	}

	private struct function createScope(required string scope) {

		var container = getPageContext().getFusionContext().hiddenScope;

		if (!structKeyExists(container, scope)) {
			container[scope] = {};
		}

		return container[scope];

	}

	private struct function getScopes() {
		return getPageContext().getFusionContext().hiddenScope;
	}

	public boolean function has(required string key) {
		return structKeyExists(getScope(), key);
	}

	public void function set(required any key, any value) {

		// key could be a struct to set the entire scope's value

		var data = getScope();

		if (structKeyExists(arguments, "value")) {
			data[key] = value;
		}
		else {
			if (namespace == "") {
				getScopes()[scope] = key;
			}
			else {
				getScopes()[scope][getKey()][namespace] = key;
			}
		}

	}

}