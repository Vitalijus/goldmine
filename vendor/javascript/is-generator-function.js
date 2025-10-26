// is-generator-function@1.1.2 downloaded from https://ga.jspm.io/npm:is-generator-function@1.1.2/index.js

import*as t from"call-bound";import*as r from"safe-regex-test";import*as a from"has-tostringtag/shams";import*as e from"get-proto";import*as o from"generator-function";var f=t;try{"default"in t&&(f=t.default)}catch(t){}var n=r;try{"default"in r&&(n=r.default)}catch(t){}var u=a;try{"default"in a&&(u=a.default)}catch(t){}var i=e;try{"default"in e&&(i=e.default)}catch(t){}var c=o;try{"default"in o&&(c=o.default)}catch(t){}var v={};var l=f;var s=n;var p=s(/^\s*(?:function)?\*/);var d=u();var m=i;var y=l("Object.prototype.toString");var g=l("Function.prototype.toString");var h=c;
/** @type {import('.')} */v=function(t){if(typeof t!=="function")return false;if(p(g(t)))return true;if(!d){var r=y(t);return r==="[object GeneratorFunction]"}if(!m)return false;var a=h();return a&&m(t)===a.prototype};var b=v;export{b as default};

