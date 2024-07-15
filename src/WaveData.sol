// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

/*


 * @title WaveData - SVG generation for Ethereum addresses
 * @dev --- Apex777.eth
 * @notice https://waveforms.apexdeployer.xyz/
 * @notice X: https://x.com/apex_ether
 * @notice Warpcast: https://warpcast.com/apex777
 * 

    This is the SVG that will be generated for each address. The SVG is a 66x66 grid with 40 vertical lines. 
    Each line is colored based on the value of the corresponding byte in the address. 
    The value of the byte is used to determine the color of the line. 
    The SVG is generated in the following hardcoded values, styles and functions. 
    You are basically changing the color of the lines based on the value of the byte in the address along with the y values of the lines.

<svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 66 66" width="600" height="600">
  <style type="text/css">
    .st1 {fill: none;stroke-width: 1;stroke-linecap: round;stroke-linejoin: round;stroke-miterlimit: 10;}
  </style>
  <rect width="66" height="66" fill="#000000"/>
  <line class="st1" x1="11.5" y1="25" x2="11.5" y2="41" stroke="#A5D6A7"/>
  <line class="st1" x1="12.6" y1="18" x2="12.6" y2="48" stroke="#CE93D8"/>
  <line class="st1" x1="13.7" y1="31" x2="13.7" y2="35" stroke="#FFCC80"/>
  <line class="st1" x1="14.8" y1="20" x2="14.8" y2="46" stroke="#9FA8DA"/>
  <line class="st1" x1="15.9" y1="19" x2="15.9" y2="47" stroke="#B39DDB"/>
  <line class="st1" x1="17.0" y1="31" x2="17.0" y2="35" stroke="#FFCC80"/>
  <line class="st1" x1="18.1" y1="25" x2="18.1" y2="41" stroke="#A5D6A7"/>
  <line class="st1" x1="19.2" y1="18" x2="19.2" y2="48" stroke="#CE93D8"/>
  <line class="st1" x1="20.3" y1="19" x2="20.3" y2="47" stroke="#B39DDB"/>
  <line class="st1" x1="21.4" y1="28" x2="21.4" y2="38" stroke="#EF9A9A"/>
  <line class="st1" x1="22.5" y1="33" x2="22.5" y2="33" stroke="#FFF59D"/>
  <line class="st1" x1="23.6" y1="28" x2="23.6" y2="38" stroke="#EF9A9A"/>
  <line class="st1" x1="24.7" y1="22" x2="24.7" y2="44" stroke="#81D4FA"/>
  <line class="st1" x1="25.8" y1="28" x2="25.8" y2="38" stroke="#EF9A9A"/>
  <line class="st1" x1="26.9" y1="26" x2="26.9" y2="40" stroke="#C5E1A5"/>
  <line class="st1" x1="28.0" y1="33" x2="28.0" y2="33" stroke="#FFF59D"/>
  <line class="st1" x1="29.1" y1="23" x2="29.1" y2="43" stroke="#80DEEA"/>
  <line class="st1" x1="30.2" y1="30" x2="30.2" y2="36" stroke="#F48FB1"/>
  <line class="st1" x1="31.3" y1="22" x2="31.3" y2="44" stroke="#81D4FA"/>
  <line class="st1" x1="32.4" y1="32" x2="32.4" y2="34" stroke="#FFE082"/>
  <line class="st1" x1="33.5" y1="26" x2="33.5" y2="40" stroke="#C5E1A5"/>
  <line class="st1" x1="34.6" y1="20" x2="34.6" y2="46" stroke="#9FA8DA"/>
  <line class="st1" x1="35.7" y1="33" x2="35.7" y2="33" stroke="#FFF59D"/>
  <line class="st1" x1="36.8" y1="33" x2="36.8" y2="33" stroke="#FFF59D"/>
  <line class="st1" x1="37.9" y1="20" x2="37.9" y2="46" stroke="#9FA8DA"/>
  <line class="st1" x1="39.0" y1="18" x2="39.0" y2="48" stroke="#CE93D8"/>
  <line class="st1" x1="40.1" y1="27" x2="40.1" y2="39" stroke="#DCE775"/>
  <line class="st1" x1="41.2" y1="25" x2="41.2" y2="41" stroke="#A5D6A7"/>
  <line class="st1" x1="42.3" y1="20" x2="42.3" y2="46" stroke="#9FA8DA"/>
  <line class="st1" x1="43.4" y1="21" x2="43.4" y2="45" stroke="#90CAF9"/>
  <line class="st1" x1="44.5" y1="24" x2="44.5" y2="42" stroke="#80CBC4"/>
  <line class="st1" x1="45.6" y1="27" x2="45.6" y2="39" stroke="#DCE775"/>
  <line class="st1" x1="46.7" y1="18" x2="46.7" y2="48" stroke="#CE93D8"/>
  <line class="st1" x1="47.8" y1="32" x2="47.8" y2="34" stroke="#FFE082"/>
  <line class="st1" x1="48.9" y1="24" x2="48.9" y2="42" stroke="#80CBC4"/>
  <line class="st1" x1="50.0" y1="23" x2="50.0" y2="43" stroke="#80DEEA"/>
  <line class="st1" x1="51.1" y1="31" x2="51.1" y2="35" stroke="#FFCC80"/>
  <line class="st1" x1="52.2" y1="22" x2="52.2" y2="44" stroke="#81D4FA"/>
  <line class="st1" x1="53.3" y1="24" x2="53.3" y2="42" stroke="#80CBC4"/>
  <line class="st1" x1="54.4" y1="19" x2="54.4" y2="47" stroke="#B39DDB"/>
</svg>



*/

contract WaveData {
    using Strings for uint256;

    /// start of SVG - hardcoded as its the same for all.
    /// view box here is a weird size (66x66) as an address is 40 pixels wide and you want to center it in the middle of the SVG
    string internal svgStart =
        '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 66 66" width="600" height="600">';

    /// style of SVG - this is some hardcoded CSS to make things look nice
    string internal style =
        '<style type="text/css">.st1 {fill: none;stroke-width: 1;stroke-linecap: round;stroke-linejoin: round;stroke-miterlimit: 10;}</style>';

    /// background of SVG - all waveforms are black background
    string internal background = '<rect width="66" height="66" fill="#000000"/>';

    // SVG end - closing tag for the SVG
    string internal svgEnd = "</svg>";

    // Precomputed x1 and x2 values
    // These are the x values for the lines in the SVG
    // these do not change for any address, solidity does not support floating point numbers so we are using strings to make life easier.
    string[40] internal xValues = [
        "11.5",
        "12.6",
        "13.7",
        "14.8",
        "15.9",
        "17.0",
        "18.1",
        "19.2",
        "20.3",
        "21.4",
        "22.5",
        "23.6",
        "24.7",
        "25.8",
        "26.9",
        "28.0",
        "29.1",
        "30.2",
        "31.3",
        "32.4",
        "33.5",
        "34.6",
        "35.7",
        "36.8",
        "37.9",
        "39.0",
        "40.1",
        "41.2",
        "42.3",
        "43.4",
        "44.5",
        "45.6",
        "46.7",
        "47.8",
        "48.9",
        "50.0",
        "51.1",
        "52.2",
        "53.3",
        "54.4"
    ];

    // colours - the 16 different colours, once for each character.
    string[] internal colors = [
        "#FFF59D", // 0
        "#FFE082", // 1 Light Amber
        "#FFCC80", // 2 Light Orange
        "#F48FB1", // 3 Light Pink
        "#FFAB91", // 4 Light Deep Orange
        "#EF9A9A", // 5 Light Red
        "#DCE775", // 6 Lime
        "#C5E1A5", // 7 Light Green
        "#A5D6A7", // 8 Green
        "#80CBC4", // 9 Teal
        "#80DEEA", // 10 Cyan
        "#81D4FA", // 11 Light Blue
        "#90CAF9", // 12 Blue
        "#9FA8DA", // 13 Indigo
        "#B39DDB", // 14 Deep Purple
        "#CE93D8" // 15 Purple
    ];

    /**
     * @dev Calculates the y1 and y2 values for the SVG lines based on the input value.
     *  we are just decided how long each line vertically is based on the value of the byte in the address.
     *
     * The SVG grid is centered at y=33. For a nibble value of 0, the line is a dot at (33, 33).
     * For other values, the line spans vertically above and below 33 by the value amount.
     */
    function getYValues(uint256 value) internal pure returns (string memory y1, string memory y2) {
        if (value == 0) {
            return ("33", "33");
        } else {
            return (Strings.toString(33 - value), Strings.toString(33 + value));
        }
    }

    /**
     * @dev Gets the color from the colors array based on the input value.
     * @param value The value used to determine the color.
     * @return The color as a string.
     *
     * This function uses the value to select a color from the colors array.
     * It uses the modulo operator to ensure the value is within the array bounds.
     */
    function getColor(uint256 value) internal view returns (string memory) {
        return colors[value % colors.length];
    }

    function addressToSVG(address _address) internal view returns (string memory) {
        // put address into bytes to break it up into chunks
        bytes memory addressBytes = abi.encodePacked(_address);

        // get all the hardcoded SVG content from the top of the contract and add it to the SVG content
        // we are adding to this over and over in the next loop
        string memory svgContent = string(abi.encodePacked(svgStart, style, background));

        // Build the SVG content for each of the bytes in the address
        for (uint256 i = 0; i < addressBytes.length; i++) {
            uint256 value = uint256(uint8(addressBytes[i]));
            uint256 nibble1 = value / 16;
            uint256 nibble2 = value % 16;

            // get color for each nibble
            string memory color1 = getColor(nibble1);
            string memory color2 = getColor(nibble2);

            (string memory y1, string memory y2) = getYValues(nibble1);
            svgContent = string(
                abi.encodePacked(
                    svgContent,
                    '<line class="st1" x1="',
                    xValues[2 * i],
                    '" y1="',
                    y1,
                    '" x2="',
                    xValues[2 * i],
                    '" y2="',
                    y2,
                    '" stroke="',
                    color1,
                    '" />'
                )
            );

            (y1, y2) = getYValues(nibble2);
            svgContent = string(
                abi.encodePacked(
                    svgContent,
                    '<line class="st1" x1="',
                    xValues[2 * i + 1],
                    '" y1="',
                    y1,
                    '" x2="',
                    xValues[2 * i + 1],
                    '" y2="',
                    y2,
                    '" stroke="',
                    color2,
                    '" />'
                )
            );
        }

        /// our svg is complete, we just need the closing tag
        svgContent = string(abi.encodePacked(svgContent, "</svg>"));

        /// hand it back to buildSVG, which then passes it to tokenURI - RAWR!
        return svgContent;
    }
}
