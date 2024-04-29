// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

uint8 constant ILLEGAL = 1;
uint8 constant POOR = 2;
uint8 constant OK = 3;
uint8 constant GREAT = 4;

struct BookVote {
    bool initialized;
    uint8 classification;
}

struct UserVotes {
    mapping(uint256 => BookVote) data;
    bool initialized;
}

contract BookVotes {
    // user Data
    address[] all_addresses;
    mapping(address => UserVotes) user_votes;

    // all Data
    uint256[] public ids;
    // map[id] index
    mapping(uint256 => uint256) public idsIndex;
    uint256[] public illegal;
    uint256[] public ok;
    uint256[] public poor;
    uint256[] public great;

    constructor() {
        ids.push(0);
    }

    function addGlobalVote(uint256 bookId, uint8 cl) public {
        if (idsIndex[bookId] == 0) {
            ids.push(bookId);
            illegal.push(0);
            ok.push(0);
            poor.push(0);
            great.push(0);
            idsIndex[bookId] = ids.length - 1;
        }

        uint index = idsIndex[bookId];

        if (cl == GREAT) {
            great[index]++;
        } else if (cl == OK) {
            ok[index]++;
        } else if (cl == POOR) {
            poor[index]++;
        } else if (cl == ILLEGAL) {
            illegal[index]++;
        }
    }

    function removeGlobalVote(uint256 bookId, uint8 cl) private {
        require(idsIndex[bookId] > 0, "cannot remove vote for book");

        uint index = idsIndex[bookId];

        if (cl == GREAT) {
            great[index]--;
        } else if (cl == OK) {
            ok[index]--;
        } else if (cl == POOR) {
            poor[index]--;
        } else if (cl == ILLEGAL) {
            illegal[index]--;
        }
    }

    function voteBooks(
        uint256[] memory bookIds,
        uint8[] memory classifications
    ) public {
        if (user_votes[msg.sender].initialized == false) {
            all_addresses.push(msg.sender);
            user_votes[msg.sender].initialized = true;
            for (uint i = 0; i < bookIds.length; i++) {
                user_votes[msg.sender].data[bookIds[i]].initialized = true;
                user_votes[msg.sender]
                    .data[bookIds[i]]
                    .classification = classifications[i];
            }
        } else {
            // user is already in the mapping
            for (uint i = 0; i < bookIds.length; i++) {
                uint8 cl = classifications[i];
                uint256 book = bookIds[i];

                if (user_votes[msg.sender].data[book].initialized) {
                    // book has already been voted upon in the past
                    if (
                        cl != user_votes[msg.sender].data[book].classification
                    ) {
                        // the book classification has been updated
                        // TODO: Runs allVotes
                        removeGlobalVote(book, cl);
                    }
                    user_votes[msg.sender].data[book].classification = cl;
                } else {
                    user_votes[msg.sender].data[book].classification = cl;
                    user_votes[msg.sender].data[book].initialized = true;
                }
                addGlobalVote(book, cl);
            }
        }
    }

    function getVotes()
        public
        view
        returns (
            uint256[] memory,
            uint256[] memory,
            uint256[] memory,
            uint256[] memory,
            uint256[] memory
        )
    {
        return (ids, illegal, poor, ok, great);
    }
}
