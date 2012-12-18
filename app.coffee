require("coffee-script")
http = require("http")
url  = require("url")

badRequest = (request) ->
  params = url.parse(request.url, true).query

  return true if parseInt(params["rows"]) > 20


server = http.createServer (request, response) ->
  if badRequest(request)
    response.writeHead(413, { 'Content-Type': 'text/plain' })
    response.end("Not supported. Try a smaller request.")
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
