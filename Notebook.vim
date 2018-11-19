python3 << endpython

import vim, subprocess

def NotebookExecute():
  line_number = NotebookClearOutput()
  line = vim.current.buffer[line_number]

  if line.startswith('$ '):
    code = line[2:]
    process = subprocess.run(code, shell=True, capture_output=True)

    result = process.stdout.decode('utf-8')
    lines = result.strip().split('\n')
    lines = ['| ' + line for line in lines]

    vim.current.buffer.append(lines, line_number + 1)

def NotebookClearOutput():
  buff = vim.current.buffer
  line_number = vim.current.range.start
  start, end = line_number, line_number

  while start >= 0 and buff[start].startswith('| '):
    start -= 1

  while end < len(vim.current.buffer) and (buff[end].startswith('| ') or buff[end].startswith('$ ')):
    end += 1

  del buff[start + 1:end]

  return start

endpython

function! NotebookExecute()
  python3 NotebookExecute()
endfunction

function! NotebookClearOutput()
  python3 NotebookClearOutput()
endfunction

function! NotebookExecuteAll()
  global/^$ /call NotebookExecute()
endfunction

function! NotebookClearOutputAll()
  global/^| /normal dd
endfunction
