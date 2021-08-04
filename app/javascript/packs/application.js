// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import 'bootstrap';

document.addEventListener('turbolinks:load', () => {
  $('[data-toggle="tooltip"]').tooltip()
})

import '../stylesheets/application'
require('admin-lte')
import '@fortawesome/fontawesome-free/js/all'

global.toastr = require('toastr')

require('jquery')
require('select2')

$(document).on('turbolinks:load', () => {
  $('#chosen-subject').select2({
    allowClear: true,
    theme: 'bootstrap'
  });
});

$(document).on('turbolinks:load', () => {
  $('#chosen-trainee').select2({
    allowClear: true,
    theme: 'bootstrap'
  });
});

$(document).on('turbolinks:load', () => {
  $('#chosen-supervisor').select2({
    allowClear: true,
    theme: 'bootstrap'
  });
});
