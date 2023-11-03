import styles from './faq.module.scss';

export default function Item({ question, answer }) {
  return (
    <div className={styles.item}>
      <p className={styles.question}>{question}</p>
      <hr />
      <p className={styles.answer}>{answer}</p>
      <hr />
    </div>
  );
}
