import { FaChevronUp, FaChevronDown } from 'react-icons/fa6';
import { motion, AnimatePresence } from 'framer-motion';
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
      <motion.button initial={false} type="button" onClick={onClick} className={styles.question}>
        <span>Q</span>
        <span>{question}</span>
        {isOpen ? <FaChevronUp size={32} /> : <FaChevronDown size={32} />}
      </motion.button>
      <AnimatePresence initial={false}>
        {isOpen && (
          <motion.section
            key="content"
            initial="collapsed"
            animate="open"
            exit="collapsed"
            variants={{
              open: { opacity: 1, height: 'auto' },
              collapsed: { opacity: 0, height: 0 },
            }}
            transition={{ duration: 0.4, ease: [0.04, 0.62, 0.23, 0.98] }}
          >
            <motion.div
              variants={{ collapsed: { opacity: 0 }, open: { opacity: 1 } }}
              transition={{ duration: 0.4 }}
              className={styles.answer}
            >
              <hr />
              <p>{answer}</p>
            </motion.div>
          </motion.section>
        )}
      </AnimatePresence>
    </div>
  );
}
