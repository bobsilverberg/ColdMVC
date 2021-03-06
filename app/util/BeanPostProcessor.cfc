/**
 * @accessors true
 */
component {

	property postProcessors;
	property beanFactory;

	public void function postProcessAfterInitialization(required any bean, required string beanName) {

		var i = "";

		for (i = 1; i <= arrayLen(postProcessors); i++) {
			beanFactory.getBean(postProcessors[i]).postProcessAfterInitialization(bean, beanName);
		}

	}

}