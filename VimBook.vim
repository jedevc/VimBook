python3 << endpython

import vim, subprocess

def VimBookExecute():
  line_number = VimBookClearOutput()
  line = vim.current.buffer[line_number]

  if line.startswith('$ '):
    code = line[2:]
    process = subprocess.run(code, shell=True, capture_output=True)

    result = process.stdout.decode('utf-8')
    lines = result.strip().split('\n')
    lines = ['| ' + line for line in lines]

    vim.current.buffer.append(lines, line_number + 1)

def VimBookClear():
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

function! VimBookExecute()
  python3 VimBookExecute()
endfunction

function! VimBookClear()
  python3 VimBookClear()
endfunction

function! VimBookExecuteAll()
  silent global/^$ /call VimBookExecute()
endfunction

function! VimBookClearAll()
  silent global/^| /normal dd
endfunction

command! VimBookExecute call VimBookExecute()
command! VimBookExecuteAll call VimBookExecuteAll()
command! VimBookClear call VimBookClear()
command! VimBookClearAll call VimBookClearAll()