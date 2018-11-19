function! NotebookExecute()
python3 << endpython
import vim, subprocess

NotebookClearOutput = vim.Function('NotebookClearOutput')
line_number = NotebookClearOutput()
line = vim.current.buffer[line_number]

if line.startswith('$ '):
  code = line[2:]
  process = subprocess.run(code, shell=True, capture_output=True)

  result = process.stdout.decode('utf-8')
  lines = result.strip().split('\n')
  lines = ['| ' + line for line in lines]

  vim.current.buffer.append(lines, line_number + 1)
endpython
endfunction

function! NotebookClearOutput()
python3 << endpython
import vim

buff = vim.current.buffer
line_number = vim.current.range.start
start, end = line_number, line_number

while start >= 0 and buff[start].startswith('| '):
  start -= 1

while end < len(vim.current.buffer) and (buff[end].startswith('| ') or buff[end].startswith('$ ')):
  end += 1

del buff[start + 1:end]

vim.command('let targetLine = ' + str(start))
endpython

return targetLine
endfunction

function! NotebookExecuteAll()
  global/^$ /call NotebookExecute()
endfunction

function! NotebookClearOutputAll()
  global/^| /normal dd
endfunction
