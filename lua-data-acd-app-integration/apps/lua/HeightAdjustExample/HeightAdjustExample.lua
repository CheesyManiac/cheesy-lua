local susHeight = 0.3

function script.windowMain()
  susHeight = ui.slider('susHeight', susHeight, 0,1,'%.2f')
  ac.store('susHeight', susHeight)  
end