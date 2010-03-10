/**
 * @accessors true
 */
component {
 
 	property modelPrefix;
	property suffixes;
 
	public void function init() {
  
		cache = {};
		
		if ($.orm.enabled()) {
			models = ormGetSessionFactory().getAllClassMetaData();
		}
		else {
			models = {};
		}
  
	}
 
	public void function injectModels(string event) {
	
		var i = "";
		var beanName = "";
		var factory = $.factory.get();
		
		var beanDefinitions = factory.getBeanDefinitionList();
		
		for (i=1; i <= arrayLen(suffixes); i++) {
		
			var suffix = suffixes[i];
			
			for (beanName in beanDefinitions) {
			
				if (right(beanName, len(suffix)) == suffix) {
				 	
					var bean = $.factory.get(beanName);
					
					var metaData = getMetaData(bean);
						
					if (structKeyExists(metaData, "model")) {						
						var model = metaData.model;
					}					
					else {						
						var model = left(beanName, len(beanName)-len(suffix));						
					}
					
					if ($.model.exists(model)) {
						
						var object = getModel(model);
						
						var singular = $.string.camelize(model);
						var plural = $.string.camelize($.string.pluralize(model));
						
						var arg = {
							"#modelPrefix##singular#" = object,
							"__Model" = object,
							"__singular" = singular,
							"__plural" = plural
						};
						
						bean.set__Model(arg);
						
					}
					
					for (model in models) {

						if (structKeyExists(bean, "set#modelPrefix##model#")) {
						
							evaluate("bean.set#modelPrefix##model#(getModel(model))");      
						
						}				
					
					}
				 
				}
			
			}
		
		}
	
	} 
	
	private any function getModel(string model) {
	
		if (!structKeyExists(cache, model)) {        
								
			var entity = entityNew(model);
			
			$.factory.autowire(entity);
			
			cache[model] = entity;  
		
		}
		
		return cache[model];
	
	}
 
}