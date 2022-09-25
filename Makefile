build:
	npm ci
	mkdir -p public
	cd pong; zip -9 -r ../pong.love . -x ".DS_Store"
	npx love.js -t "Shourya's Pong" -c pong.love public

run html:
	python3 -m http.server 9000 --directory public