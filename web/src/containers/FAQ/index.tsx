'use client';

import { useState } from 'react';
import Item from './Item';
import styles from './faq.module.scss';

interface PropsItem {
  id: number;
  question: string;
  answer: string;
}

interface Props {
  items: PropsItem[];
}

export default function IndexPage({ items }: Props) {
  const [selectedIndex, setSelectedIndex] = useState(0);

  const handleQuestionClick = (index: number) => {
    setSelectedIndex(index === selectedIndex ? 0 : index);
  };

  return (
    <div className={styles.container}>
      {items.map((item) => (
        <Item
          key={item.id}
          question={item.question}
          answer={item.answer}
          isOpen={item.id === selectedIndex}
          onClick={() => handleQuestionClick(item.id)}
        />
      ))}
    </div>
  );
}
