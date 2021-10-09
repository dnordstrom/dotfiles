/**
 * Surfingkeys settings for Firefox and Chromium
 *
 * Source: https://github.com/brookhong/Surfingkeys/issues/1325#issuecomment-721471932
 * List of settings: https://github.com/brookhong/Surfingkeys#properties-list
 */
//
// global vars
//
if (1) {
  var g_origBindingsList_normal = [];
  var g_origBindingsHash_normal = new Map();

  var g_blacklist = [
      //
      // Google
      //
      '^https?://(calendar|contacts|docs|drive|keep).google.com',
  ];
}

function _save_orig_keybindings_()
{
  var normals = [
      '$',        // scroll all the way to the right
      '0',        // scroll all the way to the left
      ';e',       // edit settings
      ';fs',      // focus scrollable element
      ';j',       // close Downloads shelf
      '<<',       // move current tab to left
      '<Ctrl-6>', // go to last active tab
      '<Ctrl-i>', // go to edit box with Vim editor
      '>>',       // move current tab to right
      '?',
      'B',        // back in bab history
      'C',        // follow link in new tab
      'D',        // history <<
      'E',        // go one tab left
      'I',        // go to edit box with Vim editor
      'R',        // go one tab right
      'S',        // history >>
      'T',        // select tabs
      'X',        // undo closing tab
      'ZR',       // restore session named "LAST"
      'ZZ',       // save session with name "LAST"
      'af',       // open link in new tab and switch to it immediately
      'b',        // search bookmarks
      'cS',       // reset scroll ['', '>>'],    // move current tab to right
      'cc',       // open link from clipboard in new tab
      'cf',       // follow link in background
      'cs',       // change scroll target
      'd',        // page down
      'e',        // page up
      'f',
      'g$',       // last tab
      'g0',       // first tab
      'gb',       // Chrome Bookmarks
      'gd',       // open Chrome Downloads
      'gf',       // open link in non-active tab
      'gh',       // Chrome History
      'gi',       // go to the first edit box
      'gs',       // show page source
      'gu',       // Go up one path in the URL
      'i',        // go to edit box
      'j',
      'k',
      'oh',       // open url from history
      'on',       // new tab
      'ox',       // open recently closed urls
      'p',        // temporarily passthru (default 1000ms)
      'q',        // click image or button
      'r',
      'sU',       // edit current url and reload
      'su',       // edit current url and load in new tab
      'w',
      'x',        // delete current tab
      'ya',       // copy link addr
      'yt',       // dup current tab
      'yv',       // copy text of an element
      'zi',       // zoom in
      'zo',       // zoom out
      'zr',       // reset zoom
  ];

  var i, key;
  for (i = 0; i < normals.length; ++i) {
      key = normals[i];
      if (g_origBindingsHash_normal.has(key) ) {
          continue;
      }

      map('__' + key, key);

      // Do NOT unmap here or keys like 'j', 'k' would stop working! Can we
      // remap all keybindings later?
      if (0) {
          unmap(key);
      }

      g_origBindingsList_normal.push('__' + key);
      g_origBindingsHash_normal.set(key, true);
  }
}

function _map_orig_(newkey, oldkey)
{
  if (! g_origBindingsHash_normal.has(oldkey) ) {
      alert(oldkey + ' not saved!');
  } else {
      map(newkey, '__' + oldkey);
  }
}

//
// global settings
//
if (1) {
  _save_orig_keybindings_();

  Hints.characters = 'abcdefhjklmnoprstuvwxyz';
  //                       gi      q
  Hints.numericHints = false;

  settings.blacklistPattern = new RegExp(g_blacklist.join('|') );

  settings.hintAlign = 'left';
  // ['', 'Caret', 'Normal']
  settings.modeAfterYank = 'Normal';
  settings.newTabPosition = 'right';
  settings.scrollStepSize = 100;
  settings.smoothScroll = true;
  settings.stealFocusOnLoad = true;
}

//
// unmap
//
if (1) {
  unmappings = [
      '<Alt-m>',  // mute/unmute current tab
      '<Alt-p>',  // pin/unpin current tab

      '<Ctrl-h>',
      '<Ctrl-j>',

      ':',    // open commands
      '.',    // repeat last action
      '[[',   // click the previous link in cur page
      ']]',   // click the next link in cur page

      ';db',  // remove bookmark for cur page
      ';dh',  // remove history older than 30 days
      ';e',
      ';i',   // insert jQuery lib in cur page
    //';j',   // close download shelf
      ';m',
      ';p',
      ';q',   // toggle mouseSelectToQuery
      ';t',   // translate selected text with Google
      ';u',
      ';U',

      'ab',   // bookmark current page
      'B',    // back in tab history
      'cc',
      'cf',
      'cq',
      'C',
      'D',
      'E',
      'gT',   // go to 1st activated tab
      'ga',   // Chrome About
      'gb',   // Chrome Bookmarks
      'gc',   // Chrome Cache
      'gd',   // Chrome Downloads
      'ge',   // Chrome Extensions
      'gh',   // Chrome History
      'gk',   // Chrome Cookies
      'gn',   // Chrome net-internals
      'go',   // open url in current tab
      'gr',   // read selected text or text from clipboard
      'gt',   // go to last activated tab
      'gu',
      'gx',   // gx[0tT$x] -- close tabs in misc way
      'oh',
      'oi',   // open incognito window
      'on',
      'ox',
      'O',
      'p',    // enter ephemeral PassThrough mode
      'q',    // click on an image or button
      'Q',    // open omnibar for translations
      'R',
      'sm',   // markdown preview
      'sql',  // show last action
      'x',
      'X',
      'yT',   // dup current tab in background
      'yt',   // dup current tab
      'ZR',
      'ZZ',

      // proxy
      ';ap', ';cp', 'cp', 'sp',

      // searches
      'ob', 'od', 'og', 'ow', 'oy',
      'sb', 'sd', 'sg', 'sh', 'ss', 'sw', 'sy',
  ];
  for (i = 0; i < unmappings.length; ++i) {
      unmap(unmappings[i]);
  }
}

//
// Insert mode
//
if (0) {
  // Input fields on some pages just does not work when you want to insert
  // a literal 'j'.
  imap('jj', '<Esc>');
}

//
// Normal mode
//
if (1) {
  /*
   * The order of map() calls are IMPORTANT! For example,
   *
   *   map('d', 'x');
   *   map(')', 'd');
   *
   * would not work as you expect.
   */
  mappings = [
      ['$', 'g$'],    // last tab
      ['<Ctrl-u>', 'e'],     // page up
      ['<Ctrl-d>', 'd'],     // page down
      ['+', 'zi'],    // zoom in
      ['-', 'zo'],    // zoom out
      ['0', 'g0'],    // first tab
      ['K', 'S'],     // history >>
      ['J', 'D'],     // history <<
      ['[', '<<'],    // move current tab to left
      [']', '>>'],    // move current tab to right

      [',,', ';e'],   // edit settings
      [',r', 'ZR'],   // restore session named "LAST"
      [',s', 'ZZ'],   // save session with name "LAST"

      [';b', 'cf'],   // follow link in background
      [';h', 'oh'],   // open url from history
      [';u', 'ox'],   // open recently closed urls
      [';Y', 'yv'],   // copy text of an element
      [';y', 'ya'],   // copy link addr

    //['B', 'b'],     // search bookmarks
      ['E', 'su'],    // edit current url and load in new tab
      ['F', 'C'],     // follow link in new tab
      ['H', 'E'],     // go one tab left
      ['L', 'R'],     // go one tab right
      ['P', 'cc'],    // open link from clipboard in new tab
      ['S', 'cS'],    // reset scroll target
      ['T', 'af'],    // open link in new tab and switch to it immediately
      ['U', 'gu'],    // Go up one path in the URL

    //['b', 'T'],     // select tabs
      ['d', 'x'],     // delete current tab
      ['e', 'sU'],    // edit current url and reload
      ['i', 'gi'],    // go to first edit box
      ['s', 'cs'],    // change scroll target
      ['t', 'on'],    // new tab
      ['u', 'X'],     // undo closing tab

      ['g$', '$'],    // scroll all the way to the right
      ['g0', '0'],    // scroll all the way to the left
      ['gf', 'gs'],   // show page source
      ['gi', 'i'],    // go to edit box
      ['gs', ';fs'],  // focus scrollable element
      ['qq', '<Ctrl-6>'],
                      // go to last active tab
      ['zz', 'zr'],   // reset zoom
  ];

  for (i = 0; i < mappings.length; ++i) {
      pair = mappings[i];
      _map_orig_(pair[0], pair[1]);
  }
}

//
// site specific
//
if (1) {
  //
  // Google sites
  //
  if (1) {
      //
      // Gmail
      //
      // Don't keep `g0' and `g$' or Gmail's shortcuts like `gl' would not work.
      unmapAllExcept(g_origBindingsList_normal, /^https:\/\/mail.google.com/);
      if (_isDomainApplicable(/mail.google.com/) ) {
          mappings = [
              ['$', 'g$'],    // last tab
              ['(', 'e'],     // page up
              [')', 'd'],     // page down
              ['+', 'zi'],    // zoom in
              ['-', 'zo'],    // zoom out
              ['[', '<<'],    // move current tab to left
              [']', '>>'],    // move current tab to right

              ['0', 'g0'],    // first tab

              ['H', 'E'],     // go one tab left
              ['J', 'j'],
              ['K', 'k'],
              ['L', 'R'],     // go one tab right

              // XXX: Quite often, Gmail would lose focus on the mails pane
              //      and 'J', 'K', '(', ')' would stop working. Here we
              //      define some keybindings to reset the scroll target.
              ['h', 'cS'],    // reset scroll target
          //  ['w', 'cS'],    // reset scroll target

              // Do NOT do this. It conflicts with Gmail's Undo (z).
          //  ['zz', 'zr'],   // reset zoom

              [',?', '?'],

              [',F', 'C'],

              [',d', 'x'],    // close cur tab
              [',f', 'f'],
              [',h', '?'],
          //  [',s', 'cs'],
              [',t', 'on'],   // new tab

              [';Y', 'yv'],   // copy text of an element
              [';y', 'ya'],   // copy link
          ];

          for (i = 0; i < mappings.length; ++i) {
              pair = mappings[i];
              _map_orig_(pair[0], pair[1]);
          }
      }

      //
      // Youtbue
      //
      if (0) {
          unmapAllExcept(g_origBindingsList_normal.concat(['<Esc>']), /^https:\/\/www.youtube.com/);
      }
      if (_isDomainApplicable(/www.youtube.com/) ) {
          mappings = [
              ['I', 'gi'],
              ['J', 'j'],
              ['K', 'k'],

              ['gi', 'gi'],

              [';d', 'x'],    // close cur tab
              [';F', 'C'],
              [';f', 'f'],
              [';Y', 'yv'],   // copy text of an element
              [';y', 'ya'],   // copy link
          ];

          for (i = 0; i < mappings.length; ++i) {
              pair = mappings[i];
              _map_orig_(pair[0], pair[1]);
          }

          site_singles = "?.,+-<>0123456789NPcfijklmotw";
          for (i = 0; i < site_singles.length; ++i) {
              unmap(site_singles[i]);
          }
      }
  }
}
