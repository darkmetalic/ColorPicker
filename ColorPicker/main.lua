--Love ColorPicker by Luiz Renato for LOVE2D

selectedcolor,bordercolor={0,0,0},{50,50,50}
x,y,c_x,c_y=0,0,150,150
radius=25

set=love.graphics.setColor
prints=love.graphics.print
rec=love.graphics.rectangle
cir=love.graphics.circle

keyrgb="c"
keyhex="h"
getcopy=false

function love.load()
palletd=love.image.newImageData("pallet.png") --pallet 300px
palletw,palleth=palletd:getDimensions()
pallet=love.graphics.newImage(palletd)
prevx=palletw+50
hand=love.mouse.getSystemCursor("hand")
end

function setpallet(x,y)
local r,g,b=palletd:getPixel(x,y)
selectedcolor={r,g,b}
end

function love.update(dt)
	if love.mouse.isDown(1) then
	istouch=true
	else
	istouch=nil
	end

	if love.keyboard.isDown("up") then
	c_y=c_y>1 and c_y-1 or 1
	setpallet(c_x,c_y)
	elseif love.keyboard.isDown("down") then
	c_y=c_y<palleth-1 and c_y+1 or palleth-1
	setpallet(c_x,c_y)
	elseif love.keyboard.isDown("left") then
	c_x=c_x>1 and c_x-1 or 1
	setpallet(c_x,c_y)
	elseif love.keyboard.isDown("right") then
	c_x=c_x<palletw-1 and c_x+1 or palletw-1
	setpallet(c_x,c_y)
	end

	getcopy = (love.system.getClipboardText()=="("..table.concat(selectedcolor,",")..")" or love.system.getClipboardText()==rgbtohex(selectedcolor)) and true or false

end

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   elseif key == keyrgb or key == "kp1" or key == "1" then
   	love.system.setClipboardText("("..table.concat(selectedcolor,",")..")")
	getcopy=true
   elseif key == keyhex or key == "kp2" or key == "2" then
   	love.system.setClipboardText(rgbtohex(selectedcolor))
	getcopy=true
   elseif key == "return" or key == "kpenter" or key == "kp0" then
   	love.system.setClipboardText("")
   	c_x,c_y=150,150
	setpallet(c_x,c_y)
   	getcopy=true
   end
end

function love.touchpressed( id, x, y, dx, dy, pressure )
istouch=true
end

function love.touchmoved( id, x, y, dx, dy, pressure )
istouch=true
end

function love.touchreleased( id, x, y, dx, dy, pressure )
istouch=nil
end

function rgbtohex(selected)
local hex={}
for i, color in ipairs(selected) do
color=string.format("%X", color*256) --hexadecimal format or "x = lowercase"
hex[i]=string.format("%02s",string.sub(color,1,2)) --min 00 strings
end
return table.concat(hex)
end

function love.draw()
x, y = love.mouse.getPosition()

--[[touches = love.touch.getTouches()
for i, id in ipairs(touches) do
x, y = love.touch.getPosition(id)
end]]

if (x>0 and x<palletw) and (y>0 and y<palleth) and istouch then
c_x,c_y=x,y
setpallet(x,y)
end

if (x>prevx+150 and x<prevx+150+200) and (y>150 and y<150+100) then
set(200,200,200) rec("fill", prevx+150, 150, 200, 100,10,10)
set(0,0,0) prints("COPY CLIP", prevx+190, 190,0,2)
love.mouse.setCursor(hand)
else
set(25,25,25) rec("fill", prevx+150, 150, 200, 100,10,10)
set(200,200,200) prints("COPY CLIP", prevx+190, 190,0,2)	
love.mouse.setCursor()
end

if ((x>prevx+150 and x<prevx+150+200) and (y>150 and y<150+100) and istouch) or getcopy then
set(0,0,100) rec("fill", prevx+150, 150, 200, 100,10,10)
set(255,255,255) prints("COPY CLIP", prevx+190, 190,0,2)	
love.mouse.setCursor()
if not getcopy then
love.system.setClipboardText("("..table.concat(selectedcolor,",")..")")
getcopy=true
end

end

set(bordercolor) rec("line", prevx+150, 150, 200, 100,10,10)

set(selectedcolor) rec("fill", prevx, 10, 100, 100)
set(bordercolor) rec("line", prevx, 10, 100, 100)

set(255,255,255,255) love.graphics.draw(pallet)
set(bordercolor) rec("line", 0, 0, palletw, palleth)
cir("line", c_x, c_y, radius, 100)

set(255,0,0,200) prints("Red "..selectedcolor[1], prevx,120)
set(0,255,0,200) prints("Green "..selectedcolor[2], prevx,150)
set(0,0,255,200) prints("Blue "..selectedcolor[3], prevx,180)

set(200,200,200)
prints("HEX #"..rgbtohex(selectedcolor), prevx,250)
prints("RGB ("..table.concat(selectedcolor,",")..")", prevx,280)

if love.system.getClipboardText()=="("..table.concat(selectedcolor,",")..")" then
set(0,0,250)
else
set(200,200,200)
end
prints("Press "..keyrgb:upper().." or 1: copy RGB", prevx+120,10,0,2)

if love.system.getClipboardText()==rgbtohex(selectedcolor) then
set(0,0,250)
else
set(200,200,200)
end
prints("Press "..keyhex:upper().." or 2: copy HEX", prevx+120,70,0,2)
end