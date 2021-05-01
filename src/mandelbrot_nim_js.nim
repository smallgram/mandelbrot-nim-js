# generate mandelbrot set using nim's js backend and html5 canvas
import html5_canvas as canvas
import dom
import strutils

type
  MBRender = ref object
    canv : Canvas
    ctx : CanvasRenderingContext2D
    data: ImageData
    iterations: int


proc gen_mandelbrot(mb:MBRender)
proc render_mandelbrot(mb:MBRender)


proc newMB(width:int = 800, height:int = 500, iterations:int = 100): MBRender =
  result = MBRender()
  result.canv = dom.document.createElement("canvas").Canvas
  result.canv.width = width 
  result.canv.height = height 
  document.body.appendChild(result.canv)
  result.ctx = result.canv.getContext2D()
  result.data = result.ctx.createImageData(result.canv.width, result.canv.height)
  result.iterations = iterations
  result.canv.style.display = "block"

  let input = dom.document.createElement("input")
  let label = dom.document.createElement("label")

  label.innerText = "iterations"
  input.value = "" & $iterations

  label.appendChild(input)
  dom.document.body.appendChild(label)

  input.addEventListener("change",
                         proc(e: Event) =
                           result.iterations = parseInt($e.target.value)
                           result.gen_mandelbrot()
                           result.render_mandelbrot())


proc set_pixel(data: ImageData, x:int, y:int, color:int)=
  data.data[data.width * y * 4 + x * 4] = uint8(color) # and 0b11000000)
  data.data[data.width * y * 4 + x * 4 + 1] = uint8(color) # and 0b00110000)
  data.data[data.width * y * 4 + x * 4 + 2] = uint8(color) # and 0b00110000)
  data.data[data.width * y * 4 + x * 4 + 3] = 255


proc gen_mandelbrot(mb:MBRender)=
  var step_x = 3.0 / float(mb.canv.width-1)
  var step_y = 2.0 / float(mb.canv.height-1)

  for i in countup(0, mb.canv.height-1):
    var ci = (float(i) * step_y) - 1.0
    for j in countup(0, mb.canv.width-1):
      var k = 0
      var zr = 0.0
      var zi = 0.0
      var cr = float(j) * step_x - 2.0
      while k <= mb.iterations and (zr*zr + zi*zi) <= 4:
        var temp = zr*zr - zi*zi + cr
        zi = 2*zr*zi + ci
        zr = temp
        k = k + 1

      mb.data.set_pixel(j,i,k)


proc render_mandelbrot(mb:MBRender)=
  mb.ctx.putImageData(mb.data,0,0)


when isMainModule:
  var m = newMB(width=500, height=500, iterations=1000)
  m.gen_mandelbrot()
  m.render_mandelbrot()

  var n = newMB(iterations=100) 
  n.gen_mandelbrot()
  n.render_mandelbrot()
