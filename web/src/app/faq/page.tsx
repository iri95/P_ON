import Index from '@/containers/FAQ';
import styles from '@/containers/FAQ/faq.module.scss';

export default function page() {
  const faq_app = [
    {
      id: 1,
      question: 'P:ON 앱은 어떤 기능을 제공하나요?',
      answer:
        'P:ON은 약속 관리를 위한 다양한 기능을 제공합니다. 약속 생성과 일정 관리, 알림 설정, 참석자 관리, 위치 확인 등의 기능을 통해 사용자들의 약속 관리를 효율적으로 도와줍니다.',
    },
    {
      id: 2,

      question: 'P:ON 앱은 어떻게 사용하나요?',
      answer:
        'P:ON은 간단하고 직관적인 사용자 인터페이스를 제공합니다. 앱을 설치한 후 회원가입을 완료하고 로그인하면 약속 생성 및 관리 기능을 사용할 수 있습니다. 사용자는 약속의 세부 정보, 참석자 등을 설정하여 약속을 관리할 수 있습니다.',
    },
    {
      id: 3,

      question: 'P:ON 앱은 어떻게 참석자를 관리하나요?',
      answer:
        'P:ON은 약속에 참석하는 사람들을 쉽게 관리할 수 있는 기능을 제공합니다. 앱 내에서 참석자를 추가할 수 있으며, 참석 여부를 확인할 수 있습니다. 또한, 참석자들과의 커뮤니케이션을 원활하게 할 수 있는 채팅 기능도 제공됩니다.',
    },
  ];
  // const faq_pinky = [
  //   {
  //     id: 1,
  //     question: '',
  //     answer: '',
  //   },
  // ];
  // const faq_memory = [
  //   {
  //     id: 1,
  //     question: '',
  //     answer: '',
  //   },
  // ];

  return (
    <>
      <h1 className={styles.title}>자주 묻는 질문</h1>
      <Index items={faq_app} />
      {/* <Index items={faq_pinky} /> */}
      {/* <Index items={faq_memory} /> */}
    </>
  );
}
