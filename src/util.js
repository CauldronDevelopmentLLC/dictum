let audio_url = 'https://translate.google.com.vn/translate_tts'
audio_url += '?ie=UTF-8&tl=fi&client=tw-ob&q='


export default {
  query_get(name) {
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
    var results = regex.exec(location.search)
    return results === null ? null :
      decodeURIComponent(results[1].replace(/\+/g, ' '))
  },


  bsearch(array, e, compare) {
    let m = 0
    let n = array.length - 1

    while (m <= n) {
      let k = (n + m) >> 1
      let cmp = compare(e, array[k])
      if (0 < cmp) m = k + 1
      else if (cmp < 0) n = k - 1
      else return k
    }

    return -m - 1
  },


  insert(array, e, compare) {
    let i = this.bsearch(array, e, compare)
    if (i < 0) array.splice(1 - i, 0, e)
    else array[i] = e
  },


  remove(array, e, compare) {
    let i = this.bsearch(array, e, compare)
    if (0 <= i) array.splice(i, 1)
  },


  html_escape(t) {
    return t
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;")
  },


  html_strip(text) {
    let div = document.createElement('div');
    div.innerHTML = text;
    return div.textContent || div.innerText || '';
  },


  link_text(text) {
    function make_link(m, p1, p2, p3) {
      let text = p3 || p1

      return `<a href="/#/word/${p1}">${text}</a>`
    }

    return text.replace(
      /\[\[([\wáâåäéóöõšșüÿž -]+)(\|([^\]]+))?\]\]/g,
      make_link)
  },


  tts(text) {
    text = this.html_strip(text)
    text = text.replaceAll('[', '').replaceAll(']', '').replaceAll('*', '')
    new Audio(audio_url + text).play()
  }
}
