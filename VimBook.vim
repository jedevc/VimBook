python3 << endpython

import vim, subprocess

def vim_book_execute():
  line_number = vim_book_clear()
  line = vim.current.buffer[line_number]

  program = None

  languages = {
    'bash': '$ ',
    'python': '>>> '
  }

  for lang in languages:
    prefix = languages[lang]
    start, end = find_lines(vim.current.buffer, line_number, prefix)
    if start is not None:
      lines = []
      for i in range(start, end + 1):
        lines.append(vim.current.buffer[i][len(prefix):])
      code = '\n'.join(lines)

      result = run_code(code, lang)

      lines = result.strip().split('\n')
      lines = ['| ' + line for line in lines]

      vim.current.buffer.append(lines, line_number + 1)

      break

def vim_book_clear():
  buff = vim.current.buffer
  line_number = vim.current.range.start
  start, end = find_lines(buff, line_number, '| ', '$ ', '>>> ')

  if start is not None:
    delstart = start

    while delstart < len(buff) and buff[delstart].startswith(('$ ', '>>> ')):
      delstart += 1
    del buff[delstart:end + 1]

    return delstart - 1

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

def run_code(code, program='bash'):
  process = subprocess.run([program], input=code.encode('utf-8'), capture_output=True)
  result = process.stdout.decode('utf-8')

  return result

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

nmap ;; :VimBookExecute<CR>
nmap ;x :VimBookExecute<CR>
nmap ;X :VimBookExecuteAll<CR>
nmap ;d :VimBookClear<CR>
nmap ;D :VimBookClearAll<CR>
