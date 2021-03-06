/**
 * @accessors true
 */
component {

	property directories;
	property suffix;

	public function setDirectories(required array directories) {
		variables.directories = listToArray(arrayToList(arguments.directories));
	}

	private void function appendSuffix() {

		var i = "";
		for (i = 1; i <= arrayLen(directories); i++) {
			directories[i] = directories[i] & suffix;
		}

	}

	public void function postProcessBeanFactory(required any beanFactory) {

		appendSuffix();
		var i = "";
		var j = "";

		var beans = {};

		for (i = 1; i <= arrayLen(directories); i++) {

			var directory = expandPath(directories[i]);
			var classPath = getClassPath(directories[i]);

			if (directoryExists(directory)) {

				var components = directoryList(directory, true, "query", "*.cfc");

				for (j = 1; j <= components.recordCount; j++) {

				 	var name = listFirst(components.name[j], ".");
					beanName = lcase(left(name, 1)) & replace(name, left(name, 1), "");

					var bean = {};
					bean.id = beanName;

					// make sure this bean isn't already explicitly defined inside a coldspring.xml file
					if (!beanFactory.containsBean(bean.id)) {

						var folder = replaceNoCase(components.directory[j] & "\", directory, "");

						folder = getClassPath(folder);

						if (folder == '') {
							bean.class = classPath & "." & name;
						}
						else {
							bean.class = classPath & "." & folder & "." & name;
						}

						if (!structKeyExists(beans, bean.id)) {

							if (isSingleton(bean.class)) {
								beans[bean.id] = bean;
							}

						}

					}

				}

			}

		}

		for (i in beans) {
			beanFactory.addBean(beans[i].id,  beans[i].class);
		}

	}

	private boolean function isSingleton(required string class) {

		var metaData = getComponentMetaData(class);

		while (structKeyExists(metaData, "extends")) {

			if (structKeyExists(metaData, "singleton")) {
				return true;
			}

			metaData = metaData.extends;

		}

		return false;

	}

	private string function getClassPath(required string directory) {

		directory = replace(directory, "\", "/", "all");

		return arrayToList(listToArray(directory, "/"), ".");

	}

}