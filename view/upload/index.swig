<html>
    <head></head>
    <body>
        <input type="file" accept="image/*" style="display: none" />
        <img src="" style="display: none" />
        <script>
            var csrf = "{{ csrf }}";
            function xhrDemo() {
                var xhr = new XMLHttpRequest();
                var opts = arguments[4] || {};
                var name = arguments[0];
                xhr.open.apply(xhr, [].slice.call(arguments, 1, 4));
                xhr.timeout = opts.timeout || 0;
                xhr.onreadystatechange = function() {
                    switch (xhr.readyState) {
                        case xhr.UNSENT:
                            console.log(`{${name}} xhr unsent, readyState: ${xhr.readyState}, status: ${xhr.status}`);
                            break;
                        case xhr.OPENED:
                            console.log(`{${name}} xhr opened, readyState: ${xhr.readyState}, status: ${xhr.status}`);
                            break;
                        case xhr.HEADERS_RECEIVED:
                            console.log(`{${name}} xhr headers_received, readyState: ${xhr.readyState}, status: ${xhr.status}`);
                            break;
                        case xhr.LOADING:
                            console.log(`{${name}} xhr loading, readyState: ${xhr.readyState}, status: ${xhr.status}`);
                            break;
                        case xhr.DONE:
                            console.log(`{${name}} xhr done, readyState: ${xhr.readyState}, status: ${xhr.status}`);
                            var data;
                            try {
                                data = JSON.parse(xhr.response);
                            } catch (e) {
                                data = xhr.response;
                            }
                            if (data.redirect) {
                                var imgElement = document.body.querySelector('img');
                                imgElement.style.display = '';
                                imgElement.setAttribute('src', data.redirect);
                            }
                            break;
                        default:
                            console.log(`{${name}} xhr unknow status: ${xhr.readyState}, status: ${xhr.status}`);
                    }
                };
                xhr.onabort = function() {
                    console.log(`{${name}} xhr trigger <onabort> event, status: ${xhr.status}`);
                }
                xhr.onerror = function() {
                    console.log(`{${name}} xhr trigger <onerror> event, status: ${xhr.status}`);
                };
                xhr.onload = function () {
                    console.log(`{${name}} xhr trigger <onload> event, status: ${xhr.status}`);
                };
                xhr.onloadend = function () {
                    console.log(`{${name}} xhr trigger <onloadend> event, status: ${xhr.status}`);
                };
                xhr.ontimeout = function () {
                    console.log(`{${name}} xhr trigger <ontimeout> event, status: ${xhr.status}`)
                };
                xhr.onprogress = function (event) {
                    var percent = event.total ? event.loaded / event.total : 0;
                    console.log(`{${name}} xhr trigger <progress> event, loaded: ${event.loaded}, total: ${event.total}, progress: ${(percent * 100).toFixed(2)}%`);
                };
                if ( xhr.upload ) {
                    xhr.upload.onabort = function() {
                        console.log(`{${name}} xhr.upload trigger <onabort> event, status: ${xhr.status}`);
                    }
                    xhr.upload.onerror = function() {
                        console.log(`{${name}} xhr.upload trigger <onerror> event, status: ${xhr.status}`);
                    };
                    xhr.upload.onload = function () {
                        console.log(`{${name}} xhr.upload trigger <onload> event, status: ${xhr.status}`);
                    };
                    xhr.upload.onloadend = function () {
                        console.log(`{${name}} xhr.upload trigger <onloadend> event, status: ${xhr.status}`);
                    };
                    xhr.upload.ontimeout = function () {
                        console.log(`{${name}} xhr.upload trigger <ontimeout> event, status: ${xhr.status}`)
                    };
                    xhr.upload.onprogress = function (event) {
                        var percent = event.total ? event.loaded / event.total : 0;
                        console.log(`{${name}} xhr.upload trigger <progress> event, loaded: ${event.loaded}, total: ${event.total}, progress: ${(percent * 100).toFixed(2)}%`);
                    };
                }
                if (opts.csrf) {
                    xhr.setRequestHeader('x-csrf-token', opts.csrf);
                }
                xhr.send(opts.formData);
            }
            function xhrFileDemo(name, method, url, async, options) {
                var fileInputElement = document.body.querySelector('input');
                fileInputElement.style.display = '';
                fileInputElement.addEventListener('change', () => {
                    var formData = new FormData();
                    formData.append('file', fileInputElement.files[0]);
                    options = options || {};
                    options.formData = formData;
                    xhrDemo.apply(null, arguments);
                }, false);
            }
            var demoConfig = {
                404: {
                    method: 'GET',
                    url: '/xhr/miss',
                    async: true
                },
                200: {
                    method: 'GET',
                    url: '/xhr/success',
                    async: true
                },
                noresponse: {
                    method: 'GET',
                    url: '/xhr/noresponse',
                    async: true
                },
                timeout: {
                    method: 'GET',
                    url: '/xhr/timeout',
                    async: true,
                    options: {
                        timeout: 100
                    }
                },
                file: {
                    method: 'POST',
                    url: `/xhr/upload`,
                    async: true,
                    options: {
                        csrf: csrf
                    }
                }
            }
            location.href.split('?').pop().split(',').forEach((key) => {
                var config;
                key = key.trim();
                config = demoConfig[key];
                if (!config) return;

                if ('file' === key) {
                    xhrFileDemo(`Test ${key}`, config.method, config.url, config.async, config.options);
                } else {
                    xhrDemo(`Test ${key}`, config.method, config.url, config.async, config.options);
                }
            });

            // file 200
            // xhrDemo('POST', '/upload', true, formData)
        </script>
    </body>
</html>