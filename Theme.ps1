$themepalette = @{
    "themePrimary" = "#272b2c";
    "themeLighterAlt" = "#e3e5e6";
    "themeLighter" = "#c9cdce";
    "themeLight" = "#b0b6b7";
    "themeTertiary" = "#989ea0";
    "themeSecondary" = "#808788";
    "themeDarkAlt" = "#697071";
    "themeDark" = "#52585a";
    "themeDarker" = "#3c4143";
    "neutralLighterAlt" = "#edefe2";
    "neutralLighter" = "#edefe2";
    "neutralLight" = "#edefe2";
    "neutralQuaternaryAlt" = "#edefe2";
    "neutralQuaternary" = "#c2c4ba";
    "neutralTertiaryAlt" = "#bbbcb3";
    "neutralTertiary" = "#595959";
    "neutralSecondary" = "#373737";
    "neutralPrimaryAlt" = "#2f2f2f";
    "neutralPrimary" = "#000000";
    "neutralDark" = "#151515";
    "black" = "#0b0b0b";
    "white" = "#edefe2";
    }

Add-SPOTheme -Identity "FocusList_Design" -Palette $themepalette -IsInverted $false