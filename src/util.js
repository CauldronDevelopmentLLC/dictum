export default {
  api(method, path, data) {
    if (this.busy) return Promise.reject(new Error('busy')).catch(() => {})

    let opts = {method}

    if (data) {
      if (method == 'PUT' || method == 'POST') {
        opts['headers'] = {'Content-Type': 'application/json'}
        opts['body']    = JSON.stringify(data)

      } else path += '?' + new URLSearchParams(data)
    }

    this.busy = true
    return fetch(path, opts).then(r => {
      this.busy = false

      if (!r.ok) return Promise.reject(r)
      if (method == 'GET') return r.json()
      else return this.update()

    }).catch(() => {this.busy = false})
  }
}
