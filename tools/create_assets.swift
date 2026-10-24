import AppKit
let types = ["technology", "arts", "sports"]
for (index, name) in types.enumerated() {
 let image = NSImage(size: NSSize(width: 1200, height: 650))
 image.lockFocus()
 let bg = [NSColor(red:0.29,green:0.16,blue:0.65,alpha:1), NSColor(red:0.78,green:0.18,blue:0.38,alpha:1), NSColor(red:0.03,green:0.43,blue:0.48,alpha:1)][index]
 bg.setFill(); NSRect(x:0,y:0,width:1200,height:650).fill()
 NSColor.white.withAlphaComponent(0.06).setStroke()
 for x in stride(from:0,through:1200,by:60) { let p=NSBezierPath(); p.move(to:NSPoint(x:x,y:0));p.line(to:NSPoint(x:x,y:650));p.stroke() }
 for y in stride(from:0,through:650,by:60) { let p=NSBezierPath(); p.move(to:NSPoint(x:0,y:y));p.line(to:NSPoint(x:1200,y:y));p.stroke() }
 let accent = [NSColor(red:0.76,green:1,blue:0.35,alpha:1),NSColor(red:1,green:0.82,blue:0.35,alpha:1),NSColor(red:0.99,green:0.57,blue:0.29,alpha:1)][index]
 NSColor.white.withAlphaComponent(0.09).setFill()
 NSBezierPath(ovalIn:NSRect(x:900,y:340,width:440,height:440)).fill()
 NSBezierPath(ovalIn:NSRect(x:-100,y:-130,width:400,height:400)).fill()
 accent.setStroke()
 for (x,y) in [(180,460),(1010,180)] {
  let star=NSBezierPath(); star.move(to:NSPoint(x:x-28,y:y));star.line(to:NSPoint(x:x+28,y:y));star.move(to:NSPoint(x:x,y:y-28));star.line(to:NSPoint(x:x,y:y+28));star.lineWidth=7;star.stroke()
 }
 accent.setFill()
 if index == 0 {
  NSBezierPath(roundedRect:NSRect(x:410,y:155,width:460,height:320),xRadius:25,yRadius:25).fill()
  bg.setFill(); NSRect(x:435,y:205,width:410,height:245).fill()
  NSColor.white.withAlphaComponent(0.09).setFill()
 NSBezierPath(ovalIn:NSRect(x:900,y:340,width:440,height:440)).fill()
 NSBezierPath(ovalIn:NSRect(x:-100,y:-130,width:400,height:400)).fill()
 accent.setStroke()
 for (x,y) in [(180,460),(1010,180)] {
  let star=NSBezierPath(); star.move(to:NSPoint(x:x-28,y:y));star.line(to:NSPoint(x:x+28,y:y));star.move(to:NSPoint(x:x,y:y-28));star.line(to:NSPoint(x:x,y:y+28));star.lineWidth=7;star.stroke()
 }
 accent.setFill(); NSRect(x:560,y:110,width:160,height:25).fill()
  let text="</>" as NSString; text.draw(at:NSPoint(x:525,y:250),withAttributes:[.font:NSFont.monospacedSystemFont(ofSize:100,weight:.bold),.foregroundColor:accent])
 } else if index == 1 {
  for i in 0..<9 { let h=CGFloat([80,160,250,340,420,340,250,160,80][i]);NSBezierPath(roundedRect:NSRect(x:350+CGFloat(i)*65,y:325-h/2,width:38,height:h),xRadius:19,yRadius:19).fill() }
 } else {
  NSBezierPath(ovalIn:NSRect(x:440,y:130,width:390,height:390)).fill()
  bg.setStroke(); let circle=NSBezierPath(ovalIn:NSRect(x:440,y:130,width:390,height:390));circle.lineWidth=9;circle.stroke()
  for x in [535,735] { let p=NSBezierPath();p.move(to:NSPoint(x:x,y:150));p.curve(to:NSPoint(x:x,y:500),controlPoint1:NSPoint(x:x-100,y:250),controlPoint2:NSPoint(x:x-100,y:400));p.lineWidth=8;p.stroke() }
  let p=NSBezierPath();p.move(to:NSPoint(x:445,y:325));p.line(to:NSPoint(x:825,y:325));p.lineWidth=8;p.stroke()
 }
 let label = ["MAKE / DISCOVER / CONNECT", "SOUND / COLOR / CULTURE", "MOVE / PLAY / BELONG"][index] as NSString
 label.draw(at:NSPoint(x:55,y:45),withAttributes:[.font:NSFont.systemFont(ofSize:22,weight:.medium),.foregroundColor:NSColor.white.withAlphaComponent(0.7)])
 image.unlockFocus()
 let rep=NSBitmapImageRep(data:image.tiffRepresentation!)!
 try! rep.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"assets/images/\(name).png"))
}
