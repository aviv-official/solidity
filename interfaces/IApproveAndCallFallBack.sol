interface IApproveAndCallFallBack{
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) external;
}