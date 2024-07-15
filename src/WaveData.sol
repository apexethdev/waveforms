// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

contract WaveData {
    using Strings for uint256;

    /// start of SVG
    string internal svgStart =
        '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 66 66" width="600" height="600">';

    /// style of SVG
    string internal style =
        '<style type="text/css">.st1 {fill: none;stroke-width: 1;stroke-linecap: round;stroke-linejoin: round;stroke-miterlimit: 10;}</style>';

    /// background of SVG
    string internal background = '<rect width="66" height="66" fill="#000000"/>';

    // SVG end
    string internal svgEnd = "</svg>";

    // Precomputed x1 and x2 values
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

    // colours
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
        "#CE93D8"  // 15 Purple
    ];

    function getYValues(uint256 value) internal pure returns (string memory y1, string memory y2) {
        if (value == 0) {
            return ("33", "33");
        } else {
            return (Strings.toString(33 - value), Strings.toString(33 + value));
        }
    }

    function getColor(uint256 value) internal view returns (string memory) {
        return colors[value % colors.length];
    }

    function addressToSVG(address _address) internal view returns (string memory) {
        // put address into bytes
        bytes memory addressBytes = abi.encodePacked(_address);

        // Build the SVG hardcoded content
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

        svgContent = string(abi.encodePacked(svgContent, "</svg>"));

        return svgContent;
    }
}
