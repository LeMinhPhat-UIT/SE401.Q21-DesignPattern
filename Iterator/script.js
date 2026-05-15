function print(str) { console.log(str) }

class AlphabeticalOrderIterator {
  constructor(collection, reverse = false) {
    this.collection = collection;
    this.reverse = reverse;
    this.position = reverse ? collection.getCount() - 1 : 0;
  }

  rewind() {
    this.position = this.reverse ? this.collection.getCount() - 1 : 0;
  }

  current() {
    return this.collection.getItems()[this.position];
  }

  key() {
    return this.position;
  }

  next() {
    const item = this.collection.getItems()[this.position];
    this.position += this.reverse ? -1 : 1;
    return item;
  }

  valid() {
    return this.reverse ? this.position >= 0 : this.position < this.collection.getCount();
  }
}

class WordsCollection {
  constructor() {
    this.items = [];
  }

  getItems() {
    return this.items;
  }

  getCount() {
    return this.items.length;
  }

  addItem(item) {
    this.items.push(item);
  }

  getIterator() {
    return new AlphabeticalOrderIterator(this);
  }

  getReverseIterator() {
    return new AlphabeticalOrderIterator(this, true);
  }
}

const collection = new WordsCollection();
collection.addItem('First');
collection.addItem('Second');
collection.addItem('Third');

const iterator = collection.getIterator();

print('Straight traversal:');
while (iterator.valid()) {
  print(iterator.next());
}

print('');
print('Reverse traversal:');
const reverseIterator = collection.getReverseIterator();
while (reverseIterator.valid()) {
  print(reverseIterator.next());
}
