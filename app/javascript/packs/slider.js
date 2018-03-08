import $ from 'jquery';
import 'rangeslider.js';
import 'rangeslider.js/dist/rangeslider.css';
console.log('hello from rangeslider');
// Initialize a new plugin instance for all
// e.g. $('input[type="range"]') elements.
$('input[type="range"]').rangeslider();

// Destroy all plugin instances created from the
// e.g. $('input[type="range"]') elements.
$('input[type="range"]').rangeslider('destroy');

// Update all rangeslider instances for all
// e.g. $('input[type="range"]') elements.
// Usefull if you changed some attributes e.g. `min` or `max` etc.
$('input[type="range"]').rangeslider({ polyfill: false});

var $document = $(document);
var selector = '[data-rangeslider]';
var $element = $(selector);
var output = document.querySelectorAll('output')[0];
// set initial output value
output.textContent = $element[0].value;
// For ie8 support
var textContent = ('textContent' in document) ? 'textContent' : 'innerText';
// Example functionality to demonstrate a value feedback
function valueOutput(element) {
    var value = element.value;
    var output = element.parentNode.getElementsByTagName('output')[0] || element.parentNode.parentNode.getElementsByTagName('output')[0];
    output[textContent] = value;
}
$document.on('input', 'input[type="range"], ' + selector, function(e) {
    valueOutput(e.target);
});
