import Item from './Item';
import styles from './faq.module.scss';

export default function index({ items }) {
  return (
    <div className={styles.container}>
      {items.map((item) => (
        <Item key={item.id} question={item.question} answer={item.answer} />
      ))}
    </div>
  );
}
