import { FaChevronUp, FaChevronDown } from 'react-icons/fa6';
import styles from './faq.module.scss';

interface Props {
  question: string;
  answer: string;
  isOpen: boolean;
  onClick: () => void;
}

export default function Item({ question, answer, isOpen, onClick }: Props) {
  return (
    <div className={`${styles.item} ${isOpen ? styles.open : ''}`}>
      <button type="button" onClick={onClick} className={styles.question}>
        <span>Q</span>
        <span>{question}</span>
        {isOpen ? <FaChevronUp size={32} /> : <FaChevronDown size={32} />}
      </button>
      {isOpen && (
        <div className={styles.answer}>
          <hr />
          <p>{answer}</p>
        </div>
      )}
    </div>
  );
}
