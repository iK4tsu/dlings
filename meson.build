project('dlings', 'd')

dependencies = [
    dependency('argparse', version: '~master', method: 'dub'),
    dependency('fswatch', version: '~>0.6.0', method: 'dub'),
]

# project source files
sources = []
subdir('source')

executable('dlings',
           sources: sources,
           include_directories: ['source'],
           dependencies: dependencies,
           install: true)
