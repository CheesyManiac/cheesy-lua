local susHeight = 0.5
ac.store('susHeight', susHeight)

function script.update(dt)
  susHeight = ac.load('susHeight')
  ac.accessCarPhysics().controllerInputs[0]=susHeight
end