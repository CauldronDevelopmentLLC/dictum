import cookie from './cookie.js'


class API {
  constructor(ctx) {this.ctx = ctx}


  async api(method, path, data) {
    let opts = {
      method,
      credentials: 'include'
    }

    if (data) {
      if (method == 'PUT' || method == 'POST') {
        opts['headers'] = {'Content-Type': 'application/json'}
        opts['body']    = JSON.stringify(data)

      } else path += '?' + new URLSearchParams(data)
    }

    let r = await fetch(path, opts)
    if (method == 'GET') return r.ok ? await r.json() : {error: r}
    return r
  }


  async get(   path, data) {return this.api('GET',    path, data)}
  async put(   path, data) {return this.api('PUT',    path, data)}
  async post(  path, data) {return this.api('POST',   path, data)}
  async delete(path, data) {return this.api('DELETE', path, data)}


  async login(attempt = false) {
    if (this.ctx.$util.query_get('state')) {
      await this.get('/api/login/google' + location.search)
      location.search = ''
      return {}
    }

    try {
      let r = await this.get('/api/login/')

      if (!r.error) {
        let route = localStorage.getItem('login_route')
        localStorage.removeItem('login_route')
        if (route) location.hash = route
      }

      if (!r.error || attempt) return r
    } catch (e) {}

    let params = {redirect_uri: location.href.split('?')[0].split('#')[0]}
    let data = await this.get('/api/login/google', params)
    cookie.set('sid', data.id);
    localStorage.setItem('login_route', location.hash)
    location.href = data.redirect
    return {}
  }


  async logout() {await this.put('/api/logout')}
}

export default API
