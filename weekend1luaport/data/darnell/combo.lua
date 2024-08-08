function goodNoteHit()
if getProperty('combo') == 100 or getProperty('combo') == 200 then
characterPlayAnim('gf', 'combo100', true);
setProperty('gf.specialAnim', true);
end
end
