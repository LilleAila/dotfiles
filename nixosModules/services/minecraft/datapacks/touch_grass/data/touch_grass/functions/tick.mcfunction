scoreboard players add @a playtime 1

# Check for 5 hours (360000 ticks) and not warned yet
# 20 tps, 5hrs = 20 * 60 * 60 *5 = 360 000
# FIXME: set low to test, should be reverted if it works.
execute as @a[scores={playtime=200}] run function touch_grass:remind
