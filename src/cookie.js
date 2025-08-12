export default {
  get(name) {
    var ca = decodeURIComponent(document.cookie).split(';')
    name = name + '='

    for (var i = 0; i < ca.length; i++) {
      var c = ca[i]
      while (c.charAt(0) == ' ') c = c.substring(1)
      if (!c.indexOf(name)) return c.substring(name.length, c.length)
    }

    return '';
  },


  set(name, value, days) {
    var d = new Date()
    d.setTime(d.getTime() + days * 24 * 60 * 60 * 1000)
    var expires = 'expires=' + d.toUTCString()
    document.cookie = name + '=' + value + ';' + expires + ';path=/' +
      ';SameSite=Lax';
  }
}
