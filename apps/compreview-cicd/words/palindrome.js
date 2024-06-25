function isPalindrome(word) {
    const charactersReversed = word.split('').reverse();
    return word === charactersReversed.join('');
}

module.exports = {
    isPalindrome
}