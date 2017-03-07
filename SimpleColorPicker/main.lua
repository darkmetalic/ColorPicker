--Color Picker by Luiz Renato for Love 2D 0.10+

selectedcolor,bordercolor={0,0,0},{50,50,50}
x,y,c_x,c_y=0,0,0,0
radius=25

set=love.graphics.setColor
prints=love.graphics.print
rec=love.graphics.rectangle
cir=love.graphics.circle

function love.load()
palletd=love.image.newImageData("pallet.png") --pallet 300px
palletw,palleth=palletd:getDimensions()
pallet=love.graphics.newImage(palletd)
prevx=palletw+50
end

function love.update(dt)
	if love.mouse.isDown(1) then
	istouch=true
	else
	istouch=nil
	end
end

function love.keyreleased(key)
   if key == "escape" then
      love.event.quit()
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
r,g,b=palletd:getPixel(x,y)
selectedcolor={r,g,b}
end

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
end