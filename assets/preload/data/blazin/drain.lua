function opponentNoteHit()
if not hideHud then
    health = getProperty('health')
        setProperty('health', health -0.1);
    end

  if hideHud then
      health = getProperty('health')
      if getProperty('health') > 0.02264 then
          setProperty('health', health- 0.02263);
      end
    end
end
