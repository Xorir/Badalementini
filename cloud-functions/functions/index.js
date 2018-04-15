let functions = require('firebase-functions')
let admin = require('firebase-admin')
admin.initializeApp(functions.config().firebase)

exports.announceProduct = functions.database
.ref('notifications/{productId}')
.onCreate(event => {
	let product = event.data.val()
	sendNotification(product)
})

function sendNotification(product) {
	let postalCode = product.postalCode
	let userName = product.userName
	let infoText = product.infoText

	let payload = {
		notification: {
			title: 'Missin Pet!',
			body: infoText,
			sound: 'default'
		}
	}

	console.log(payload)

	let topic = postalCode
	admin.messaging().sendToTopic(topic, payload)

}