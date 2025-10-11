set_version('1.0.0')
set_license('LGPL-3.0')

add_repositories('kozharskyad-xmake-repo https://github.com/kozharskyad/xmake-repo.git')

add_rules('mode.debug', 'mode.release')
add_requires('omsfw 1.0.0')

target('omsfw-example')
  set_kind('binary')
  add_files('src/*.mm', 'src/*.m')
  add_includedirs('src/include')
  add_packages('omsfw')
