window.__STORAGEMOCK = {}
function getVault() {
	if ('localStorage' in window) {
		return localStorage
	} else {
		return {
			getItem: function(key) { return window.__STORAGEMOCK[key] },
			setItem: function(key, value) { window.__STORAGEMOCK[key] = value }
		}
	}
}

function loadKeys() {
	const vault = getVault()
	const dataString = vault.getItem('apiKeys')
	const data = JSON.parse(dataString)
	if (data != null && data.length > 0) {
		data.forEach(item => {
			let element = document.getElementById(item.id)
			if (element) {
				element.value = item.value
			}
		})
	}
}

function saveKeys() {
	const vault = getVault()
	let data = []
	let storables = document.querySelectorAll('[data-allow-storage="yes"]')
	storables.forEach(s => {
		let item = { id: s.id, value: s.value }
		data.push(item)
	})
	vault.setItem('apiKeys', JSON.stringify(data))
}

function setDefault(form) {
	const field = form.querySelector('input[type="search"][placeholder]')
	if (field != null && field.value == '') {
		const placeholder = field.getAttribute('placeholder')
		const [input, defaultValue] = placeholder.match(/^E\.g\.:?\s*'(.*?)'\s*$/i)
		if (defaultValue != '') {
			field.value = defaultValue
		}
	}
}

const nav = document.querySelector('body > nav ul')
nav.addEventListener('click', focusForm)

const allows = document.querySelectorAll('form[data-allow-default]')
allows.forEach(f => {
	f.addEventListener('submit', (e) => {
		setDefault(f)
	})
})

function focusForm(event) {
	const containerRef = event.target.getAttribute('href')

	const container = document.querySelector(containerRef)
	const field = container?.querySelector(`form input[type="search"]`)
	if (field != null) {
		event.preventDefault()
		window.requestAnimationFrame(f => {
			field.select()
			field.focus()
			container.scrollIntoView({ behavior: 'smooth' })
		})
	}
}
