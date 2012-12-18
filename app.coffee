require("coffee-script")
http = require("http")
url  = require("url")

badRequest = (url) ->
  false

server = http.createServer (request, response) ->
  if badRequest(request.url)
    response.end()
    return

  proxyOptions = {
    hostname: "index.websolr.com"
    port:     80
    method:   "GET"
    path:     "/solr/825a039f852#{url.parse(request.url).path}"
  }

  proxyRequest = http.request proxyOptions, (proxyResponse) ->
    response.writeHead(proxyResponse.statusCode, proxyResponse.headers)
    proxyResponse.pipe(response)

  request.pipe(proxyRequest)

server.listen(8080)
