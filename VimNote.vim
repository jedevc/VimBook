python3 << endpython

import vim, subprocess

def VimNoteExecute():
  line_number = VimNoteClearOutput()
  line = vim.current.buffer[line_number]

  if line.startswith('$ '):
    code = line[2:]
    process = subprocess.run(code, shell=True, capture_output=True)

    result = process.stdout.decode('utf-8')
    lines = result.strip().split('\n')
    lines = ['| ' + line for line in lines]

    vim.current.buffer.append(lines, line_number + 1)

def VimNoteClear():
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

function! VimNoteExecute()
  python3 VimNoteExecute()
endfunction

function! VimNoteClear()
  python3 VimNoteClear()
endfunction

function! VimNoteExecuteAll()
  silent global/^$ /call VimNoteExecute()
endfunction

function! VimNoteClearAll()
  silent global/^| /normal dd
endfunction

command! VimModeExecute call VimNoteExecute()
command! VimModeExecuteAll call VimNoteExecuteAll()
command! VimNoteClear call VimNoteClear()
command! VimNoteClearAll call VimNoteClearAll()
