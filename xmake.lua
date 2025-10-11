set_license('LGPL-3.0')
add_rules('mode.debug', 'mode.release')
add_requires('objfw 1.4.1')

target('omsfw')
  set_kind('static')
  add_files('src/*.mm')
  add_includedirs('src/include', {public = true})
  add_packages('objfw', {public = true})
