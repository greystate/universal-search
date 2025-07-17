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

function setDefault(form, fromForm, template) {
	const field = form.querySelector('input[type="search"][placeholder]')
	let source = field
	let input, defaultValue

	if (fromForm != null) {
		source = document.querySelector(`#search-${fromForm} input[type="search"]`)
	}

	if (field != null && field.value == '') {
		if (template != null && source.value != '') {
			defaultValue = template.replace('$value', source.value)
		} else {
			const placeholder = field.getAttribute('placeholder'); // ';' is necessary here... ¯\_(ツ)_/¯
			[input, defaultValue] = placeholder.match(/^E\.g\.:?\s*'(.*?)'\s*$/i)
		}

		if (defaultValue != '') {
			field.value = defaultValue
		}
	}
}

const nav = document.querySelector('body > nav ul')
nav.addEventListener('click', focusForm)

const allows = document.querySelectorAll('form[data-allow-default]')

allows.forEach(f => {
	const from = f.dataset.defaultFrom
	const template = f.dataset.defaultTemplate
	f.addEventListener('submit', (e) => {
		setDefault(f, from, template)
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
