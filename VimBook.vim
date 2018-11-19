python3 << endpython

import vim, subprocess

def vim_book_execute():
  line_number = vim_book_clear()
  line = vim.current.buffer[line_number]

  if line.startswith('$ '):
    code = line[2:]
    process = subprocess.run(code, shell=True, capture_output=True)

    result = process.stdout.decode('utf-8')
    lines = result.strip().split('\n')
    lines = ['| ' + line for line in lines]

    vim.current.buffer.append(lines, line_number + 1)

def vim_book_clear():
  buff = vim.current.buffer
  line_number = vim.current.range.start
  start, end = find_lines(buff, line_number, '| ', '$ ')

  if start is not None:
    del buff[start + 1:end + 2]

  return start

def find_lines(buff, ln, *matches):
  start, end = ln, ln

  while start >= 0 and buff[start].startswith(matches):
    start -= 1
  while end < len(vim.current.buffer) and buff[end].startswith(matches):
    end += 1

  start += 1
  end -= 1

  if start <= end:
    return start, end
  else:
    return None, None

endpython

function! VimBookExecute()
  python3 vim_book_execute()
endfunction

function! VimBookClear()
  python3 vim_book_clear()
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
