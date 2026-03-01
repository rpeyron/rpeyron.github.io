let navLangs = [navigator.language]; // Use navigator.langages to match all browsers langages
// navLangs = [...navLangs, ...navigator.languages];
navLangs = navLangs.map(lang => lang.split("-")[0]); // Keep only first part of langage
let navLang = navLangs[0];
let navLangFiltered = navLangs.filter(value => ((value == curLang) || (Object.keys(pageTrans).includes(value))))

function startGoogleTranslate() {
  // Load Google only when asked
  var script = document.createElement('script');
  script.src = "//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit";
  document.head.appendChild(script); //or something of the likes
  document.querySelector(".img-google-translate").style.display = "none";
  document.querySelector(".lang-cur-menu").style.display = "block";
}

function googleTranslateElementInit() {
  new google.translate.TranslateElement({
      pageLanguage: curLang,  
      layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
      autoDisplay: true,
      // gaTrack: true, gaId: 'UA-xx'
    }, 'google_translate_element');
  doGTranslate(navLang +  '|' + curLang);
}

function detectIfGoogleTranslateNeeded() {
  if (navLangFiltered.length > 0) { 
    // If we have a translation for the browser langage we mask google translate
    document.querySelector(".menu-google-translate").style.display = "none";
  } else {
    document.querySelector(".menu-google-translate").style.display = "";
  }
}

function detectIfRedirectNeeded() {
  if ((navLangFiltered.length > 0) && (navLang != curLang) && (!document.location.hash.includes("lang"))) {
    document.location.href = document.location.origin + pageTrans[navLang]
  }
  console.log()
}

detectIfRedirectNeeded();

detectIfGoogleTranslateNeeded();